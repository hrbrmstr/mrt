#include <Rcpp.h>
#include <time.h>

#include <stdlib.h>
#include <netinet/in.h>
#include <sys/socket.h>
#include <arpa/inet.h>

#include <string>
#include <unordered_map>

extern "C" {
#include <bgpdump_lib.h>
}

using namespace Rcpp;

Rcpp::Function msg("message");
Rcpp::Function warn("warning");

//' Convert RouteViews RIB (bgpdump table dump v2) to subnet/asn map
//'
//' It presently ONLY works with the modern RouteViews v2 format.
//'
//' @param path path to RouteViews RIB (can be compressed)
//' @param progress if \code{TRUE} output a message every 50,000 records.
//' @return \code{tbl_df} (tibble) or \code{NULL}
//' @export
// [[Rcpp::export]]
DataFrame rib_to_asn_table(std::string path, bool progress=false) {

  std::string full_path(R_ExpandFileName(path.c_str()));

  if (progress) msg("Reading " + full_path);

  BGPDUMP *dump_file = bgpdump_open_dump(full_path.c_str());

  if (dump_file == NULL) return(R_NilValue);

  BGPDUMP_ENTRY *entry = NULL;

  unsigned int i=0;

  std::unordered_map <std::string, std::string> asn_table;
  std::string prefix, mask, asn;

  do {

    if (progress & ((i % 50000) == 0)) msg(std::to_string(i) + " records processed");

    if ((i++ % 10000) == 0) { Rcpp::checkUserInterrupt(); };

    entry = bgpdump_read_next(dump_file);

    if (entry != NULL) {

      switch(entry->type) {

      case BGPDUMP_TYPE_TABLE_DUMP_V2:
        BGPDUMP_TABLE_DUMP_V2_PREFIX *e = &entry->body.mrtd_table_dump_v2_prefix;
        if (e->afi == AFI_IP) {
          prefix = inet_ntoa(e->prefix.v4_addr);
          for (unsigned int j=0; j<e->entry_count; j++) {
            attributes_t *attr = e->entries[j].attr;
            if ((attr->flag & ATTR_FLAG_BIT(BGP_ATTR_AS_PATH)) != 0) {
              mask = std::to_string(e->prefix_length);
              asn = std::string(attr->aspath->str);
              asn = asn.substr(asn.rfind(" ") + 1);
              asn_table[prefix + "/" + mask] = asn;
            };
          };
        };
        break;

      }

    }

    bgpdump_free_mem(entry);

  } while (dump_file->eof == 0);

  // at this point, we have two choices, return a simple named vector or
  // return a pre-built data_frame. as the latter is generally more useful,
  // we'll return that. if there's a desire to change this by someone for
  // their own fork, remove all this cruft below and just return(wrap(asn_table))
  // and change the return type to a CharacterVector.

  std::vector<std::string> keys;
  std::vector<std::string> values;

  keys.reserve(asn_table.size());
  values.reserve(asn_table.size());

  for(std::unordered_map<std::string, std::string>::iterator iter = asn_table.begin();
      iter != asn_table.end(); ++iter) {
    keys.push_back(iter->first);
    values.push_back(iter->second);
  };

  DataFrame df = DataFrame::create(_["cidr"] = keys,
                           _["asn"] = values,
                           _["stringsAsFactors"] = false);

  df.attr("class") = CharacterVector::create("tbl_df", "tbl", "data.frame");

  return(df);

}
