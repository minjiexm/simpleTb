##------------------------------------------------------------------------------
##   Copyright 2019 Veri5.org
##   All Rights Reserved Worldwide
##
##   Licensed under the Apache License, Version 2.0 (the
##   "License"); you may not use this file except in
##   compliance with the License.  You may obtain a copy of
##   the License at
##
##       http://www.apache.org/licenses/LICENSE-2.0
##
##   Unless required by applicable law or agreed to in
##   writing, software distributed under the License is
##   distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
##   CONDITIONS OF ANY KIND, either express or implied.  See
##   the License for the specific language governing
##   permissions and limitations under the License.
##------------------------------------------------------------------------------

export WIN_MODE     = 0
export QUESTA_HOME  = c:/EDATools/Mentor/questasim64_10.6c
export UVM_INST_DIR = $(shell pwd)/..
export BITS         = 64

export PROJ_ROOT    = $(shell pwd)/..
export MODEL_HOME   = $(QUESTA_HOME)
export UVM_VERSION  = 1.1d
export UVM_HOME     = $(UVM_INST_DIR)/uvm-$(UVM_VERSION)

export TEST_NAME    = network_test_topology
export FILE_LIST    = $(PROJ_ROOT)/filelist/network_tb.fl
export SIM_ARGS     = +PRINT_ALL_ARGS=0 +UVM_VERBOSITY=UVM_HIGH 

#Arg lists
# +AUTO_MAC_TABLE_INIT=0
# +UVM_CONFIG_DB_TRACE

readme:
	@echo "----------------------------------------------------------------------"
	@echo " README                                                               "
	@echo "----------------------------------------------------------------------"
	@echo "Before start to run demo test case                                    "
	@echo "there are 4 env variables need to be set  :                           "
	@echo "  WIN_MODE     : Indicate whether OS is windows or not.               "
	@echo "                 If OS is Windows, Please set WIN_MODE to 1.          "
	@echo "  QUESTA_HOME  : the questa sim install path.                         "
	@echo "                 For example "c:/EDATools/Mentor/questasim64_10.6c"   "
	@echo "  UVM_INST_DIR : Upper level Path of UVM lib.                         "
	@echo "                 For exmaple "c:/EDATools/UVM"                        "
	@echo "                 In this simple TB, we are using uvm-1.1d             "
	@echo "                 So UVM_HOME will be $(UVM_INST_DIR)/uvm-1.1d         "
	@echo "  BTIS         : Compile mode. For Linux suport 32 and 64 bits mode.  "
	@echo "                 For Windows, right now only support 64bits mode.     "
	@echo "                                                                      "
	@echo "  If you don't have any pre-install UVM libs.                         "
	@echo "  Please use below command to download:                               "
	@echo "    cd $(PROJ_ROOT) && git submodule update --init --recursive        "
	@echo "  This will clone UVM 1.1d into $(PROJ_ROOT)/uvm-1.1d                 "
	@echo "  By default, UVM_INST_DIR already set to $(PROJ_ROOT)                "
	@echo "                                                                      "
	@echo "  Please modify line 1 to 4 of this file                              " 
	@echo "  to set them to match to your env.                                   "
	@echo "                                                                      "
	@echo "----------------------------------------------------------------------"
	@echo "Below is the run commands to run the demo tests:                      "
	@echo "----------------------------------------------------------------------"
	@echo "Run topology test case command :                                      "
	@echo "    make TEST_NAME=network_test_topology all | tee sim.log            "
	@echo "  or use simple command :                                             "
	@echo "    make topology                                                     "
	@echo "                                                                      "
	@echo "Run tradition sequence test case command :                            "
	@echo "    make TEST_NAME=network_test_sequence all | tee sim.log            "
	@echo "  or use simple command :                                             "
	@echo "    make topology                                                     "
	@echo "                                                                      "
	@echo "You can use below command to pass simulaton args :                    "
	@echo "    make SIM_ARGS=+UVM_VERBOSITY [target(s)]                          "
	@echo "  for example :                                                       "
	@echo "    make SIM_ARGS=+UVM_VERBOSITY=UVM_DEBUG topology                   "
	@echo "----------------------------------------------------------------------"


topology:
	make TEST_NAME=network_test_topology all | tee sim.log


seq:
	make TEST_NAME=network_test_sequence all | tee sim.log


include Makefile.questa

