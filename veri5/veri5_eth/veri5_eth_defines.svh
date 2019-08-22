/******************************************************************************
 * (C) Copyright 2014 VERI5 Consulting
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 *
 * NAME:        veri5_eth_defines.sv
 * PROJECT:     veri5_eth
 * Description: This file declare all used defines.
 *******************************************************************************/

`ifndef __VERI5_ETH_DEFINES
    //protection against multiple includes
    `define __VERI5_ETH_DEFINES

`ifndef VERI5_ETH_PREAMBLE_WIDTH
    //width of the Preamble field
    `define VERI5_ETH_PREAMBLE_WIDTH 56
`endif

`ifndef VERI5_ETH_SFD_WIDTH
    //width of the "Start Frame Delimiter" field
    `define VERI5_ETH_SFD_WIDTH 8
`endif

`ifndef VERI5_ETH_ADDRESS_WIDTH
    //width of the "Address" fields
    `define VERI5_ETH_ADDRESS_WIDTH 48
`endif

`ifndef VERI5_ETH_LENGTH_TYPE_WIDTH
    //width of the "Length/Type" field
    `define VERI5_ETH_LENGTH_TYPE_WIDTH 16
`endif

`ifndef VERI5_ETH_FCS_WIDTH
    //width of the "Frame Check Sequence" field
    `define VERI5_ETH_FCS_WIDTH 32
`endif

`ifndef VERI5_ETH_DATA_WIDTH
    //width of the basic unit in the "Data" field
    `define VERI5_ETH_DATA_WIDTH 8
`endif

`ifndef VERI5_ETH_SNAP_PROTOCOL_IDENTIFIER_WIDTH
    //width of the "Protocol Identifier" field from SNAP packet
    `define VERI5_ETH_SNAP_PROTOCOL_IDENTIFIER_WIDTH 40
`endif

`ifndef VERI5_ETH_EXTENSION_WIDTH
    //width of the basic unit in the "Extensions" field
    `define VERI5_ETH_EXTENSION_WIDTH 1
`endif

`ifndef VERI5_ETH_MIN_JUMBO_PAYLOAD_SIZE
    //minimum payload length of the Jumbo frame, in bytes
    `define VERI5_ETH_MIN_JUMBO_PAYLOAD_SIZE 1501
`endif

`ifndef VERI5_ETH_MAX_JUMBO_PAYLOAD_SIZE
    //maximum payload length of the Jumbo frame, in bytes
    `define VERI5_ETH_MAX_JUMBO_PAYLOAD_SIZE 9000
`endif

`ifndef VERI5_ETH_PAUSE_PACKET_DESTINATION_ADDRESS
    //Ethernet Pause packet - Destination Address 
    `define VERI5_ETH_PAUSE_PACKET_DESTINATION_ADDRESS `VERI5_ETH_ADDRESS_WIDTH'h0180C2000001
`endif

`ifndef VERI5_ETH_PFC_PACKET_DESTINATION_ADDRESS
    //Ethernet PFC packet - Destination Address 
    `define VERI5_ETH_PFC_PACKET_DESTINATION_ADDRESS `VERI5_ETH_ADDRESS_WIDTH'h0180C2000001
`endif

`ifndef VERI5_ETH_PAUSE_OPCODE_WIDTH
    //Ethernet Pause packet - width of the "Opcode" field
    `define VERI5_ETH_PAUSE_OPCODE_WIDTH 16
`endif

`ifndef VERI5_ETH_PAUSE_PARAMETER_WIDTH
    //Ethernet Pause packet - width of the "Parameter" field
    `define VERI5_ETH_PAUSE_PARAMETER_WIDTH 16
`endif

`ifndef VERI5_ETH_PAUSE_OPCODE
    //Ethernet Pause packet - opcode
    `define VERI5_ETH_PAUSE_OPCODE `VERI5_ETH_PAUSE_OPCODE_WIDTH'h0001
`endif

`ifndef VERI5_ETH_PAUSE_PARAMETER_MAX
    //Ethernet Pause packet - maximum value of the "Parameter" field
    `define VERI5_ETH_PAUSE_PARAMETER_MAX `VERI5_ETH_PAUSE_PARAMETER_WIDTH'hFFFF
`endif

`ifndef VERI5_ETH_PAUSE_PARAMETER_MIN
    //Ethernet Pause packet - minimum value of the "Parameter" field
    `define VERI5_ETH_PAUSE_PARAMETER_MIN `VERI5_ETH_PAUSE_PARAMETER_WIDTH'h0000
`endif

`ifndef VERI5_ETH_PFC_OPCODE_WIDTH
    //Ethernet PFC packet - width of the "Opcode" field
    `define VERI5_ETH_PFC_OPCODE_WIDTH 16
`endif

`ifndef VERI5_ETH_PFC_OPCODE
    //Ethernet PFC packet - opcode
    `define VERI5_ETH_PFC_OPCODE `VERI5_ETH_PFC_OPCODE_WIDTH'h0101
`endif

`ifndef VERI5_ETH_PFC_CLASS_ENABLE_VECTOR_WIDTH
    //Ethernet PFC packet - width of the "Class Enable Vector" field
    `define VERI5_ETH_PFC_CLASS_ENABLE_VECTOR_WIDTH 16
`endif

`ifndef VERI5_ETH_PFC_CLASS_ENABLE_VECTOR_MAX
    //Ethernet PFC packet - maximum value of the "Class Enable Vector" field
    `define VERI5_ETH_PFC_CLASS_ENABLE_VECTOR_MAX `VERI5_ETH_PFC_CLASS_ENABLE_VECTOR_WIDTH'h00FF
`endif

`ifndef VERI5_ETH_PFC_CLASS_ENABLE_VECTOR_MIN
    //Ethernet PFC packet - minimum value of the "Class Enable Vector" field
    `define VERI5_ETH_PFC_CLASS_ENABLE_VECTOR_MIN `VERI5_ETH_PFC_CLASS_ENABLE_VECTOR_WIDTH'h0000
`endif

`ifndef VERI5_ETH_PFC_NUMBER_OF_PARAMETERS
    //Ethernet PFC packet - number of parameters
    `define VERI5_ETH_PFC_NUMBER_OF_PARAMETERS 8
`endif

`ifndef VERI5_ETH_PFC_PARAMETER_WIDTH
    //Ethernet PFC packet - width of the "Parameter" field
    `define VERI5_ETH_PFC_PARAMETER_WIDTH 16
`endif

`ifndef VERI5_ETH_PFC_PARAMETER_MAX
    //Ethernet PFC packet - maximum value of the "Parameter" field
    `define VERI5_ETH_PFC_PARAMETER_MAX `VERI5_ETH_PAUSE_PARAMETER_WIDTH'hFFFF
`endif

`ifndef VERI5_ETH_PFC_PARAMETER_MIN
    //Ethernet PFC packet - minimum value of the "Parameter" field
    `define VERI5_ETH_PFC_PARAMETER_MIN `VERI5_ETH_PAUSE_PARAMETER_WIDTH'h0000
`endif

`ifndef VERI5_ETH_PAYLOAD_SIZE_MIN
    //Ethernet packet - minimum payload size
    `define VERI5_ETH_PAYLOAD_SIZE_MIN 46
`endif

`ifndef VERI5_ETH_PAYLOAD_SIZE_MAX
    //Ethernet packet - maximum payload size
    `define VERI5_ETH_PAYLOAD_SIZE_MAX 1500
`endif

`ifndef VERI5_ETH_MAGIC_PACKET_TARGET_MAC_REPETITIONS
    //the number of times the target address is repeated in the magic packet
    `define VERI5_ETH_MAGIC_PACKET_TARGET_MAC_REPETITIONS 6
`endif

`ifndef VERI5_ETH_MAGIC_PACKET_SYNCH_STREAM_WIDTH
    //width of the magic packet pattern which identifies the target address
    `define VERI5_ETH_MAGIC_PACKET_SYNCH_STREAM_WIDTH 48
`endif

`ifndef VERI5_ETH_MAGIC_PACKET_SYNCH_STREAM
    //default magic packet pattern which identifies the target address
    `define VERI5_ETH_MAGIC_PACKET_SYNCH_STREAM 48'hFFFFFFFFFFFF
`endif

`ifndef VERI5_ETH_DEFAULT_SNAP_PACKET_DSAP
    //default value for DSAP field in SNAP packet
    `define VERI5_ETH_DEFAULT_SNAP_PACKET_DSAP 8'hAA
`endif

`ifndef VERI5_ETH_DEFAULT_SNAP_PACKET_SSAP
    //default value for SSAP field in SNAP packet
    `define VERI5_ETH_DEFAULT_SNAP_PACKET_SSAP 8'hAA
`endif

`ifndef VERI5_ETH_DEFAULT_SNAP_PACKET_CTL
    //default value for CTL field in SNAP packet
    `define VERI5_ETH_DEFAULT_SNAP_PACKET_CTL 8'h03
`endif

`ifndef VERI5_ETH_JUMBO_CLIENT_DATA_SIZE_WIDTH
    //Jumbo packet - client data size width
    `define VERI5_ETH_JUMBO_CLIENT_DATA_SIZE_WIDTH 32
`endif

`ifndef VERI5_ETH_ETHERNET_CONFIGURATION_TESTING_SKIPCOUNT_WIDTH
    //Ethernet Configuration Testing packet - skipcount width
    `define VERI5_ETH_ETHERNET_CONFIGURATION_TESTING_SKIPCOUNT_WIDTH 16
`endif

`ifndef VERI5_ETH_ETHERNET_CONFIGURATION_TESTING_FUNCTION_WIDTH
    //Ethernet Configuration Testing packet - function width
    `define VERI5_ETH_ETHERNET_CONFIGURATION_TESTING_FUNCTION_WIDTH 16
`endif

`ifndef VERI5_ETH_GROUP_ADDRESS_MASK
    //Ethernet Configuration Testing Source Address Mask - used to avoid Source Address to be a group address
    `define VERI5_ETH_GROUP_ADDRESS_MASK 48'hFEFFFFFFFFFF
`endif

`ifndef VERI5_ETH_ETHERNET_CONFIGURATION_TESTING_REPLY_FUNCTION
    //Ethernet Configuration Testing packet - reply function
    `define VERI5_ETH_ETHERNET_CONFIGURATION_TESTING_REPLY_FUNCTION 1
`endif

`ifndef VERI5_ETH_ETHERNET_CONFIGURATION_TESTING_FORWARD_FUNCTION
    //Ethernet Configuration Testing packet - forward function
    `define VERI5_ETH_ETHERNET_CONFIGURATION_TESTING_FORWARD_FUNCTION 2
`endif

`ifndef VERI5_ETH_ETHERNET_CONFIGURATION_TESTING_DATA_MAX
    //Ethernet Configuration Testing packet - max data
    `define VERI5_ETH_ETHERNET_CONFIGURATION_TESTING_DATA_MAX 1496
`endif

`ifndef VERI5_ETH_ETHERNET_CONFIGURATION_TESTING_DATA_MIN
    //Ethernet Configuration Testing packet - min data
    `define VERI5_ETH_ETHERNET_CONFIGURATION_TESTING_DATA_MIN 42
`endif

`ifndef VERI5_ETH_HSR_PATH_WIDTH
    //HSR Standard packet - width of the "Path" field
    `define VERI5_ETH_HSR_PATH_WIDTH 4
`endif

`ifndef VERI5_ETH_HSR_STANDARD_SIZE_WIDTH
    //HSR Standard packet - width of the "Size" field
    `define VERI5_ETH_HSR_STANDARD_SIZE_WIDTH 12
`endif

`ifndef VERI5_ETH_HSR_STANDARD_SEQ_WIDTH
    //HSR Standard packet - width of the "Seq" field
    `define VERI5_ETH_HSR_STANDARD_SEQ_WIDTH 16
`endif

`ifndef VERI5_ETH_HSR_STANDARD_PROTOCOL_WIDTH
    //HSR Standard packet - width of the "Protocol" field
    `define VERI5_ETH_HSR_STANDARD_PROTOCOL_WIDTH 16
`endif

`ifndef VERI5_ETH_HSR_STANDARD_LPDU_MAX
    //HSR Standard packet - maximum value of the "LPDU" field
    `define VERI5_ETH_HSR_STANDARD_LPDU_MAX 1500
`endif

`ifndef VERI5_ETH_HSR_STANDARD_LPDU_MIN
    //HSR Standard packet - minimum value of the "LPDU" field
    `define VERI5_ETH_HSR_STANDARD_LPDU_MIN 40
`endif

//the code of the magic packet used to identify the information in generic payload
`define VERI5_ETH_PACKET_MAGIC_CODE 32'h0000_0000

//the code of the jumbo packet used to identify the information in generic payload
`define VERI5_ETH_PACKET_JUMBO_CODE 32'h0000_0001

//the code of the snap packet used to identify the information in generic payload
`define VERI5_ETH_PACKET_SNAP_CODE 32'h0000_0002

//the code of the pause packet used to identify the information in generic payload
`define VERI5_ETH_PACKET_PAUSE_CODE 32'h0000_0003

//the code of the pfc pause packet used to identify the information in generic payload
`define VERI5_ETH_PACKET_PFC_PAUSE_CODE 32'h0000_0004

//the code of the length packet used to identify the information in generic payload
`define VERI5_ETH_PACKET_LENGTH_CODE 32'h0000_0005

//the code of the ethernet configuration testing packet used to identify the information in generic payload
`define VERI5_ETH_PACKET_ETHERNET_CONFIGURATION_TESTING_CODE 32'h0000_0006

//the code of the IPV4 packet used to identify the information in generic payload
`define VERI5_ETH_PACKET_IPV4_CODE 32'h0000_0007

//the code of the hsr packet used to identify the information in generic payload
`define VERI5_ETH_PACKET_HSR_STANDARD_CODE 32'h0000_0008

//the code of the ARP packet used to identify the information in generic payload
`define VERI5_ETH_PACKET_ARP_CODE 32'h0000_0009

//the code of the fcoe packet used to identify the information in generic payload
`define VERI5_ETH_PACKET_FCOE_CODE 32'h0000_000A

//the code of the PTP packet used to identify the information in generic payload
`define VERI5_ETH_PACKET_PTP_CODE 32'h0000_000C

`ifndef VERI5_ETH_FIELD_SEPARATOR
    //the field separator when printing a packet
    `define VERI5_ETH_FIELD_SEPARATOR ", "
`endif

`ifndef VERI5_ETH_IPV4_HEADER_VERSION_VALUE
    //IPV4 packet - version value
    `define VERI5_ETH_IPV4_HEADER_VERSION_VALUE 4
`endif

`ifndef VERI5_ETH_IPV4_HEADER_VERSION_WIDTH
    //IPV4 packet - version width
    `define VERI5_ETH_IPV4_HEADER_VERSION_WIDTH 4
`endif

`ifndef VERI5_ETH_IPV4_HEADER_IHL_WIDTH
    //IPV4 packet - IHL (Internet Header Length) width
    `define VERI5_ETH_IPV4_HEADER_IHL_WIDTH 4
`endif

`ifndef VERI5_ETH_IPV4_HEADER_DSCP_WIDTH
    //IPV4 packet - DSCP (Differentiated Services Code Point) width
    `define VERI5_ETH_IPV4_HEADER_DSCP_WIDTH 6
`endif

`ifndef VERI5_ETH_IPV4_HEADER_ECN_WIDTH
    //IPV4 packet - ECN (Explicit Congestion Notification) width
    `define VERI5_ETH_IPV4_HEADER_ECN_WIDTH 2
`endif

`ifndef VERI5_ETH_IPV4_HEADER_TOTAL_LENGTH_WIDTH
    //IPV4 packet - Total Length width
    `define VERI5_ETH_IPV4_HEADER_TOTAL_LENGTH_WIDTH 16
`endif

`ifndef VERI5_ETH_IPV4_HEADER_IDENTIFICATION_WIDTH
    //IPV4 packet - Identification width
    `define VERI5_ETH_IPV4_HEADER_IDENTIFICATION_WIDTH 16
`endif

`ifndef VERI5_ETH_IPV4_HEADER_FLAGS_WIDTH
    //IPV4 packet - Flags width
    `define VERI5_ETH_IPV4_HEADER_FLAGS_WIDTH 3
`endif

`ifndef VERI5_ETH_IPV4_HEADER_FRAGMENT_OFFSET_WIDTH
    //IPV4 packet - Fragment Offset width
    `define VERI5_ETH_IPV4_HEADER_FRAGMENT_OFFSET_WIDTH 13
`endif

`ifndef VERI5_ETH_IPV4_HEADER_TTL_WIDTH
    //IPV4 packet - TTL (Time To Live) width
    `define VERI5_ETH_IPV4_HEADER_TTL_WIDTH 8
`endif

`ifndef VERI5_ETH_IPV4_HEADER_PROTOCOL_WIDTH
    //IPV4 packet - Protocol width
    `define VERI5_ETH_IPV4_HEADER_PROTOCOL_WIDTH 8
`endif

`ifndef VERI5_ETH_IPV4_HEADER_CHECKSUM_WIDTH
    //IPV4 packet - Checksum width
    `define VERI5_ETH_IPV4_HEADER_CHECKSUM_WIDTH 16
`endif

`ifndef VERI5_ETH_IPV4_HEADER_SOURCE_IP_ADDRESS_WIDTH
    //IPV4 packet - Source IP address width
    `define VERI5_ETH_IPV4_HEADER_SOURCE_IP_ADDRESS_WIDTH 32
`endif

`ifndef VERI5_ETH_IPV4_HEADER_DESTINATION_IP_ADDRESS_WIDTH
    //IPV4 packet - Destination IP address width
    `define VERI5_ETH_IPV4_HEADER_DESTINATION_IP_ADDRESS_WIDTH 32
`endif

`ifndef VERI5_ETH_IPV4_HEADER_OPTION_WIDTH
    //IPV4 packet - Option width
    `define VERI5_ETH_IPV4_HEADER_OPTION_WIDTH 32
`endif

`ifndef VERI5_ETH_IPV4_REQUIRED_REASSEMBLE_LENGTH
    //The largest datagram that any host is required to be able to reassemble
    `define VERI5_ETH_IPV4_REQUIRED_REASSEMBLE_LENGTH 576
`endif

`ifndef VERI5_ETH_FCOE_VERSION_WIDTH
    //FCOE packet - width of "Version" field
    `define VERI5_ETH_FCOE_VERSION_WIDTH 4
`endif

`ifndef VERI5_ETH_FCOE_RESERVED_BEFORE_SOF_SIZE
    //FCOE packet - value of "Reserved Before SOF size" field
    `define VERI5_ETH_FCOE_RESERVED_BEFORE_SOF_SIZE 100
`endif

`ifndef VERI5_ETH_FCOE_SOF_WIDTH
    //FCOE packet - width of "SOF" field
    `define VERI5_ETH_FCOE_SOF_WIDTH 8
`endif

`ifndef VERI5_ETH_ARP_HTYPE_WIDTH
    //Hardware type (HTYPE)
    `define VERI5_ETH_ARP_HTYPE_WIDTH 16
`endif

`ifndef VERI5_ETH_ARP_PTYPE_WIDTH
    //Protocol type (PTYPE)
    `define VERI5_ETH_ARP_PTYPE_WIDTH 16
`endif

`ifndef VERI5_ETH_ARP_HLEN_WIDTH
    //Hardware length (HLEN)
    `define VERI5_ETH_ARP_HLEN_WIDTH 8
`endif

`ifndef VERI5_ETH_ARP_PLEN_WIDTH
    //Protocol length (PLEN)
    `define VERI5_ETH_ARP_PLEN_WIDTH 8
`endif

`ifndef VERI5_ETH_ARP_OPER_WIDTH
    //Operation
    `define VERI5_ETH_ARP_OPER_WIDTH 16
`endif

`ifndef VERI5_ETH_ARP_SHA_WIDTH
    //Sender hardware address (SHA)
    `define VERI5_ETH_ARP_SHA_WIDTH 48
`endif

`ifndef VERI5_ETH_ARP_SPA_WIDTH
    //Sender protocol address (SPA)
    `define VERI5_ETH_ARP_SPA_WIDTH 32
`endif

`ifndef VERI5_ETH_ARP_THA_WIDTH
    //Target hardware address (THA)
    `define VERI5_ETH_ARP_THA_WIDTH 48
`endif

`ifndef VERI5_ETH_ARP_TPA_WIDTH
    //Target protocol address (TPA)
    `define VERI5_ETH_ARP_TPA_WIDTH 32
`endif

`ifndef VERI5_ETH_ARP_OPER_REQUEST
    //The value of Operation field in ARP packet for Request
    `define VERI5_ETH_ARP_OPER_REQUEST 1
`endif

`ifndef VERI5_ETH_ARP_OPER_REPLY
    //The value of Operation field in ARP packet for Reply
    `define VERI5_ETH_ARP_OPER_REPLY 2
`endif

`ifndef VERI5_ETH_FCOE_SOFf
    //numerical value of "SOF" field for literal "SOFf" value
    `define VERI5_ETH_FCOE_SOFf 8'h28
`endif

`ifndef VERI5_ETH_FCOE_SOFi2
    //numerical value of "SOF" field for literal "SOFi2" value
    `define VERI5_ETH_FCOE_SOFi2 8'h2D
`endif

`ifndef VERI5_ETH_FCOE_SOFn2
    //numerical value of "SOF" field for literal "SOFn2" value
    `define VERI5_ETH_FCOE_SOFn2 8'h35
`endif

`ifndef VERI5_ETH_FCOE_SOFi3
    //numerical value of "SOF" field for literal "SOFi3" value
    `define VERI5_ETH_FCOE_SOFi3 8'h2E
`endif

`ifndef VERI5_ETH_FCOE_SOFn3
    //numerical value of "SOF" field for literal "SOFn3" value
    `define VERI5_ETH_FCOE_SOFn3 8'h36
`endif

`ifndef VERI5_ETH_FCOE_SOFi4
    //numerical value of "SOF" field for literal "SOFi4" value
    `define VERI5_ETH_FCOE_SOFi4 8'h29
`endif

`ifndef VERI5_ETH_FCOE_SOFn4
    //numerical value of "SOF" field for literal "SOFn4" value
    `define VERI5_ETH_FCOE_SOFn4 8'h31
`endif

`ifndef VERI5_ETH_FCOE_SOFc4
    //numerical value of "SOF" field for literal "SOFc4" value
    `define VERI5_ETH_FCOE_SOFc4 8'h39
`endif

`ifndef VERI5_ETH_FCOE_EOF_WIDTH
    //FCOE packet - width of "EOF" field
    `define VERI5_ETH_FCOE_EOF_WIDTH 8
`endif

`ifndef VERI5_ETH_FCOE_RESERVED_AFTER_EOF_SIZE
    //FCOE packet - value of "Reserved Before EOF size" field
    `define VERI5_ETH_FCOE_RESERVED_AFTER_EOF_SIZE 24
`endif

`ifndef VERI5_ETH_FCOE_EOFn
    //numerical value of "EOF" field for literal "EOFn" value
    `define VERI5_ETH_FCOE_EOFn 8'h41
`endif

`ifndef VERI5_ETH_FCOE_EOFt
    //numerical value of "EOF" field for literal "EOFt" value
    `define VERI5_ETH_FCOE_EOFt 8'h42
`endif

`ifndef VERI5_ETH_FCOE_EOFni
    //numerical value of "EOF" field for literal "EOFni" value
    `define VERI5_ETH_FCOE_EOFni 8'h49
`endif

`ifndef VERI5_ETH_FCOE_EOFa
    //numerical value of "EOF" field for literal "EOFa" value
    `define VERI5_ETH_FCOE_EOFa 8'h50
`endif

`ifndef VERI5_ETH_FCOE_EOFrt
    //numerical value of "EOF" field for literal "EOFrt" value
    `define VERI5_ETH_FCOE_EOFrt 0x44
`endif

`ifndef VERI5_ETH_FCOE_EOFdt
    //numerical value of "EOF" field for literal "EOFdt" value
    `define VERI5_ETH_FCOE_EOFdt 0x46
`endif

`ifndef VERI5_ETH_FCOE_EOFdti
    //numerical value of "EOF" field for literal "EOFdti" value
    `define VERI5_ETH_FCOE_EOFdti 0x4E
`endif

`ifndef VERI5_ETH_FCOE_EOFrti
    //numerical value of "EOF" field for literal "EOFrti" value
    `define VERI5_ETH_FCOE_EOFrti 0x4F
`endif

`ifndef VERI5_ETH_FCOE_FC_FRAME_SIZE_MIN
    //FCOE packet - minimum value of the "FC Frame Size" field
    `define VERI5_ETH_FCOE_FC_FRAME_SIZE_MIN 28
`endif

`ifndef VERI5_ETH_FCOE_FC_FRAME_SIZE_MAX
    //FCOE packet - maximum value of the "FC Frame Size" field
    `define VERI5_ETH_FCOE_FC_FRAME_SIZE_MAX 2180
`endif

`ifndef VERI5_ETH_FCOE_FC_FRAME_CRC_SIZE_IN_BYTES
    //FCOE packet - CRC size in bytes
    `define VERI5_ETH_FCOE_FC_FRAME_CRC_SIZE_IN_BYTES 4
`endif

//minimum header length in bits of the Ethernet frame
`define VERI5_ETH_MINIMUM_HEADER_LENGTH_IN_BITS (`VERI5_ETH_IPV4_HEADER_VERSION_WIDTH + `VERI5_ETH_IPV4_HEADER_IHL_WIDTH + \
            `VERI5_ETH_IPV4_HEADER_DSCP_WIDTH + `VERI5_ETH_IPV4_HEADER_ECN_WIDTH + \
            `VERI5_ETH_IPV4_HEADER_TOTAL_LENGTH_WIDTH + `VERI5_ETH_IPV4_HEADER_IDENTIFICATION_WIDTH + \
            `VERI5_ETH_IPV4_HEADER_FLAGS_WIDTH + `VERI5_ETH_IPV4_HEADER_FRAGMENT_OFFSET_WIDTH + \
            `VERI5_ETH_IPV4_HEADER_TTL_WIDTH + `VERI5_ETH_IPV4_HEADER_PROTOCOL_WIDTH + \
            `VERI5_ETH_IPV4_HEADER_CHECKSUM_WIDTH + `VERI5_ETH_IPV4_HEADER_SOURCE_IP_ADDRESS_WIDTH + \
`VERI5_ETH_IPV4_HEADER_DESTINATION_IP_ADDRESS_WIDTH) \

//minimum header length in bytes of the Ethernet frame
`define VERI5_ETH_MINIMUM_HEADER_LENGTH_IN_BYTES (`VERI5_ETH_MINIMUM_HEADER_LENGTH_IN_BITS / 8) \

//minimum header length in words of the Ethernet frame
`define VERI5_ETH_MINIMUM_HEADER_LENGTH_IN_WORDS (`VERI5_ETH_MINIMUM_HEADER_LENGTH_IN_BITS / 32) \

`ifndef VERI5_ETH_CRC32_CCITT_SEED
    //seed for computing CRC32
    `define VERI5_ETH_CRC32_CCITT_SEED 32'hFFFFFFFF
`endif

`ifndef VERI5_ETH_DEFAULT_MIN_FRAME_SIZE
    //default minimum frame size
    `define VERI5_ETH_DEFAULT_MIN_FRAME_SIZE 64
`endif

`ifndef VERI5_ETH_PTP_TRANSPORT_SPECIFIC_WIDTH
    //PTP packet - width of the "Transport Specific" field
    `define VERI5_ETH_PTP_TRANSPORT_SPECIFIC_WIDTH 4
`endif

`ifndef VERI5_ETH_PTP_IN_IEEE1588
    //numerical value of "Transport Specific" field for literal "PTP_in_IEEE1588" value
    `define VERI5_ETH_PTP_IN_IEEE1588 0
`endif

`ifndef VERI5_ETH_PTP_IN_802_1_AS
    //numerical value of "Transport Specific" field for literal "PTP_in_802_1_as" value
    `define VERI5_ETH_PTP_IN_802_1_AS 1
`endif

`ifndef VERI5_ETH_PTP_MESSAGE_TYPE_WIDTH
    //PTP packet - width of the "Message Type" field
    `define VERI5_ETH_PTP_MESSAGE_TYPE_WIDTH 4
`endif

`ifndef VERI5_ETH_PTP_SYNCMESSAGE
    //numerical value of "Message Type" field for literal "PTP_SyncMessage" value
    `define VERI5_ETH_PTP_SYNCMESSAGE 0
`endif

`ifndef VERI5_ETH_PTP_DELAY_REQMESSAGE
    //numerical value of "Message Type" field for literal "PTP_Delay_ReqMessage" value
    `define VERI5_ETH_PTP_DELAY_REQMESSAGE 1
`endif

`ifndef VERI5_ETH_PTP_PDELAY_REQMESSAGE
    //numerical value of "Message Type" field for literal "PTP_Pdelay_ReqMessage" value
    `define VERI5_ETH_PTP_PDELAY_REQMESSAGE 2
`endif

`ifndef VERI5_ETH_PTP_PDELAY_RESPMESSAGE
    //numerical value of "Message Type" field for literal "PTP_Pdelay_RespMessage" value
    `define VERI5_ETH_PTP_PDELAY_RESPMESSAGE 3
`endif

`ifndef VERI5_ETH_PTP_FOLLOW_UPMESSAGE
    //numerical value of "Message Type" field for literal "PTP_Follow_UpMessage" value
    `define VERI5_ETH_PTP_FOLLOW_UPMESSAGE 8
`endif

`ifndef VERI5_ETH_PTP_DELAY_RESPMESSAGE
    //numerical value of "Message Type" field for literal "PTP_Delay_RespMessage" value
    `define VERI5_ETH_PTP_DELAY_RESPMESSAGE 9
`endif

`ifndef VERI5_ETH_PTP_PDELAY_RESP_FOLLOW_UPMESSAGE
    //numerical value of "Message Type" field for literal "PTP_Pdelay_Resp_Follow_UpMessage" value
    `define VERI5_ETH_PTP_PDELAY_RESP_FOLLOW_UPMESSAGE 10
`endif

`ifndef VERI5_ETH_PTP_ANNOUNCEMESSAGE
    //numerical value of "Message Type" field for literal "PTP_AnnounceMessage" value
    `define VERI5_ETH_PTP_ANNOUNCEMESSAGE 11
`endif

`ifndef VERI5_ETH_PTP_SIGNALLINGMESSAGE
    //numerical value of "Message Type" field for literal "PTP_SignallingMessage" value
    `define VERI5_ETH_PTP_SIGNALLINGMESSAGE 12
`endif

`ifndef VERI5_ETH_PTP_MANAGEMENTMESSAGE
    //numerical value of "Message Type" field for literal "PTP_ManagementMessage" value
    `define VERI5_ETH_PTP_MANAGEMENTMESSAGE 13
`endif

`ifndef VERI5_ETH_PTP_SYNCMESSAGE_CTRL
    //numerical value of "Control Field" field for literal "PTP_SyncMessage_ctrl" value
    `define VERI5_ETH_PTP_SYNCMESSAGE_CTRL 0
`endif

`ifndef VERI5_ETH_PTP_DELAY_REQMESSAGE_CTRL
    //numerical value of "Control Field" field for literal "PTP_Delay_ReqMessage_ctrl" value
    `define VERI5_ETH_PTP_DELAY_REQMESSAGE_CTRL 1
`endif

`ifndef VERI5_ETH_PTP_FOLLOW_UPMESSAGE_CTRL
    //numerical value of "Control Field" field for literal "PTP_Follow_UpMessage_ctrl" value
    `define VERI5_ETH_PTP_FOLLOW_UPMESSAGE_CTRL 2
`endif

`ifndef VERI5_ETH_PTP_DELAY_RESPMESSAGE_CTRL
    //numerical value of "Control Field" field for literal "PTP_Delay_RespMessage_ctrl" value
    `define VERI5_ETH_PTP_DELAY_RESPMESSAGE_CTRL 3
`endif

`ifndef VERI5_ETH_PTP_MANAGEMENTMESSAGE_CTRL
    //numerical value of "Control Field" field for literal "PTP_ManagementMessage_ctrl" value
    `define VERI5_ETH_PTP_MANAGEMENTMESSAGE_CTRL 4
`endif

`ifndef VERI5_ETH_PTP_RESERVED_1_WIDTH
    //PTP packet - width of the "Reserved " field
    `define VERI5_ETH_PTP_RESERVED_1_WIDTH 4
`endif

`ifndef VERI5_ETH_PTP_VERSION_WIDTH
    //PTP packet - width of the "Version" field
    `define VERI5_ETH_PTP_VERSION_WIDTH 4
`endif

`ifndef VERI5_ETH_PTP_MESSAGE_LENGTH_WIDTH
    //PTP packet - width of the "Message Length" field
    `define VERI5_ETH_PTP_MESSAGE_LENGTH_WIDTH 16
`endif

`ifndef VERI5_ETH_PTP_DOMAIN_NUMBER_WIDTH
    //PTP packet - width of the "Domain Number" field
    `define VERI5_ETH_PTP_DOMAIN_NUMBER_WIDTH 8
`endif

`ifndef VERI5_ETH_PTP_RESERVED_2_WIDTH
    //PTP packet - width of the "Reserved" field
    `define VERI5_ETH_PTP_RESERVED_2_WIDTH 8
`endif

`ifndef VERI5_ETH_PTP_FLAGS_WIDTH
    //PTP packet - width of the "Flags" field
    `define VERI5_ETH_PTP_FLAGS_WIDTH 16
`endif

`ifndef VERI5_ETH_PTP_CORRECTION_FIELD_WIDTH
    //PTP packet - width of the "Correction Field" field
    `define VERI5_ETH_PTP_CORRECTION_FIELD_WIDTH 64
`endif

`ifndef VERI5_ETH_PTP_RESERVED_3_WIDTH
    //PTP packet - width of the "Reserved" field
    `define VERI5_ETH_PTP_RESERVED_3_WIDTH 32
`endif

`ifndef VERI5_ETH_PTP_SOURCE_PORT_IDENTITY_SIZE
    //PTP packet - size of "Source Port Identity" field
    `define VERI5_ETH_PTP_SOURCE_PORT_IDENTITY_SIZE 10
`endif

`ifndef VERI5_ETH_PTP_SEQUENCE_ID_WIDTH
    //PTP packet - width of the "Sequence ID" field
    `define VERI5_ETH_PTP_SEQUENCE_ID_WIDTH 16
`endif

`ifndef VERI5_ETH_PTP_CONTROL_FIELD_WIDTH
    //PTP packet - width of the "Control Field" field
    `define VERI5_ETH_PTP_CONTROL_FIELD_WIDTH 8
`endif

`ifndef VERI5_ETH_PTP_LOG_MESSAGE_WIDTH
    //PTP packet - width of the "Log Message" field
    `define VERI5_ETH_PTP_LOG_MESSAGE_WIDTH 8
`endif

`ifndef VERI5_ETH_PTP_ORIGIN_TIMESTAMP_SIZE
    //PTP packet - size of "Origin Timestamp" field
    `define VERI5_ETH_PTP_ORIGIN_TIMESTAMP_SIZE 10
`endif

`ifndef VERI5_ETH_PTP_ANNOUNCE_MESSAGE_CURRENT_UTC_OFFSET_WIDTH
    //PTP packet - width of the "Current UTC Offset" field from "Announce Message" body
    `define VERI5_ETH_PTP_ANNOUNCE_MESSAGE_CURRENT_UTC_OFFSET_WIDTH 16
`endif

`ifndef VERI5_ETH_PTP_ANNOUNCE_MESSAGE_RESERVED_WIDTH
    //PTP packet - width of the "Reserved" field from "Announce Message" body
    `define VERI5_ETH_PTP_ANNOUNCE_MESSAGE_RESERVED_WIDTH 8
`endif

`ifndef VERI5_ETH_PTP_ANNOUNCE_MESSAGE_GRANDMASTER_PRIORITY_1_WIDTH
    //PTP packet - width of the "Priority 1" field from "Announce Message" body
    `define VERI5_ETH_PTP_ANNOUNCE_MESSAGE_GRANDMASTER_PRIORITY_1_WIDTH 8
`endif

`ifndef VERI5_ETH_PTP_ANNOUNCE_MESSAGE_GRANDMASTER_CLOCK_QUALITY_WIDTH
    //PTP packet - width of the "Clock Quality" field from "Announce Message" body
    `define VERI5_ETH_PTP_ANNOUNCE_MESSAGE_GRANDMASTER_CLOCK_QUALITY_WIDTH 32
`endif

`ifndef VERI5_ETH_PTP_ANNOUNCE_MESSAGE_GRANDMASTER_PRIORITY_2_WIDTH
    //PTP packet - width of the "Priority 2" field from "Announce Message" body
    `define VERI5_ETH_PTP_ANNOUNCE_MESSAGE_GRANDMASTER_PRIORITY_2_WIDTH 8
`endif

`ifndef VERI5_ETH_PTP_ANNOUNCE_MESSAGE_GRANDMASTER_IDENTITY_WIDTH
    //PTP packet - width of the "Grandmaster Identity" field from "Announce Message" body
    `define VERI5_ETH_PTP_ANNOUNCE_MESSAGE_GRANDMASTER_IDENTITY_WIDTH 64
`endif

`ifndef VERI5_ETH_PTP_ANNOUNCE_MESSAGE_STEPS_REMOVED_WIDTH
    //PTP packet - width of the "Steps Removed" field from "Announce Message" body
    `define VERI5_ETH_PTP_ANNOUNCE_MESSAGE_STEPS_REMOVED_WIDTH 16
`endif

`ifndef VERI5_ETH_PTP_ANNOUNCE_MESSAGE_TIME_SOURCE_WIDTH
    //PTP packet - width of the "Time Source" field from "Announce Message" body
    `define VERI5_ETH_PTP_ANNOUNCE_MESSAGE_TIME_SOURCE_WIDTH 8
`endif


//-----------------------------------------------------------------------//
//  Define Header Length
//-----------------------------------------------------------------------//
`ifndef VERI5_ETH_HDR_L2_LEN
  //Ethernet L2 Header Length in Bytes
  `define VERI5_ETH_HDR_L2_LEN 12  //Just Mac DA and Mac SA, total 12 bytes
`endif

`endif //__VERI5_ETH_DEFINES