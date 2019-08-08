//-----------------------------------------------------------------------------
//   Copyright 2019 Veri5.org
//   All Rights Reserved Worldwide
//
//   Licensed under the Apache License, Version 2.0 (the
//   "License"); you may not use this file except in
//   compliance with the License.  You may obtain a copy of
//   the License at
//
//       http://www.apache.org/licenses/LICENSE-2.0
//
//   Unless required by applicable law or agreed to in
//   writing, software distributed under the License is
//   distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
//   CONDITIONS OF ANY KIND, either express or implied.  See
//   the License for the specific language governing
//   permissions and limitations under the License.
//-----------------------------------------------------------------------------

`ifndef UVME_LOG_REPORT_SERVER_SVH
`define UVME_LOG_REPORT_SERVER_SVH


//Class: uvme_log_report_server
//UVM report server

class uvme_log_report_server extends uvm_report_server;

  //Function: compose_message
  //
  //Format UVM message print log
  
  virtual function string compose_message( uvm_severity severity,
                                           string name,
                                           string id,
                                           string message,
                                           string filename,
                                           int line );

    // Declare function-internal vars
    string filename_nopath = "";
    uvm_severity_type severity_type = uvm_severity_type'( severity );

    begin
       // Extract just the file name, remove the preceeding path
       foreach(filename[i])
       begin
         if (filename[i]=="/")
		   filename_nopath = "";
         else
		   filename_nopath = {filename_nopath, filename[i]};
       end

       // number of initial spaces in the second line
       // = 8 + 1(space) + 1(@) + 7 + 2("ns") + 3(spaces) + 2(indentation) = 24
       // return $psprintf( "%-8s @%7tns%3s\"%s\" >%s(%0d)\n%24s%s [%s]",             
       //                   severity_type.name(), $time/1000.00, " ",
       //                   name, filename_nopath, line, " ", message, id );   
       return $psprintf( "%-8s @%7tns%3s%s (%0d) > \"%s\" [%s] %s",
                         severity_type.name(), $time/1000.00, " ",
                         filename_nopath, line, name, id, message);
    end

  endfunction: compose_message
  
endclass: uvme_log_report_server


`endif //UVME_LOG_REPORT_SERVER_SVH
