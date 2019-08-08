NDSummary.OnToolTipsLoaded("File:network/network_component.svh",{20:"<div class=\"NDToolTip TClass LSystemVerilog\"><div class=\"NDClassPrototype\" id=\"NDClassPrototype20\"><div class=\"CPEntry TClass Current\"><div class=\"CPName\">network_component</div></div></div><div class=\"TTSummary\">network_component is the base class for network classes like host/port/switch ....</div></div>",79:"<div class=\"NDToolTip TFunction LSystemVerilog\"><div id=\"NDPrototype79\" class=\"NDPrototype WideForm CStyle\"><table><tr><td class=\"PBeforeParameters\"><span class=\"SHKeyword\">function new</span> (</td><td class=\"PParametersParentCell\"><table class=\"PParameters\"><tr><td class=\"PType first\"><span class=\"SHKeyword\">string</span>&nbsp;</td><td class=\"PName last\">name,</td></tr><tr><td class=\"PType first\">uvm_component&nbsp;</td><td class=\"PName last\">parent</td></tr></table></td><td class=\"PAfterParameters\">)</td></tr></table></div><div class=\"TTSummary\">Initializes the object.</div></div>",44:"<div class=\"NDToolTip TFunction LSystemVerilog\"><div id=\"NDPrototype44\" class=\"NDPrototype WideForm CStyle\"><table><tr><td class=\"PBeforeParameters\"><span class=\"SHKeyword\">virtual function void</span> build_phase(</td><td class=\"PParametersParentCell\"><table class=\"PParameters\"><tr><td class=\"PType first\">uvm_phase&nbsp;</td><td class=\"PName last\">phase</td></tr></table></td><td class=\"PAfterParameters\">)</td></tr></table></div><div class=\"TTSummary\">Connect to a neighbour, the neighbour will be the upstearm neighbour</div></div>",80:"<div class=\"NDToolTip TFunction LSystemVerilog\"><div id=\"NDPrototype80\" class=\"NDPrototype WideForm CStyle\"><table><tr><td class=\"PBeforeParameters\"><span class=\"SHKeyword\">virtual function void</span> connect_upstream(</td><td class=\"PParametersParentCell\"><table class=\"PParameters\"><tr><td class=\"first\"></td><td class=\"PType\">network_component&nbsp;</td><td class=\"PName\">neighbour,</td><td></td><td class=\"last\"></td></tr><tr><td class=\"PModifierQualifier first\">input <span class=\"SHKeyword\">int</span>&nbsp;</td><td class=\"PType\"><span class=\"SHKeyword\">unsigned</span>&nbsp;</td><td class=\"PName\">port_idx&nbsp;</td><td class=\"PDefaultValueSeparator\">=&nbsp;</td><td class=\"PDefaultValue last\"><span class=\"SHNumber\">0</span></td></tr></table></td><td class=\"PAfterParameters\">)</td></tr></table></div><div class=\"TTSummary\">Connect to a neighbour, the neighbour will be the upstearm neighbour</div></div>",91:"<div class=\"NDToolTip TFunction LSystemVerilog\"><div class=\"TTSummary\">Return uvme_transaction_input of giving index</div></div>",92:"<div class=\"NDToolTip TFunction LSystemVerilog\"><div class=\"TTSummary\">Return uvme_transaction_output of giving index</div></div>",93:"<div class=\"NDToolTip TFunction LSystemVerilog\"><div id=\"NDPrototype93\" class=\"NDPrototype WideForm CStyle\"><table><tr><td class=\"PBeforeParameters\"><span class=\"SHKeyword\">virtual function</span> network_component get_ds_neighour(</td><td class=\"PParametersParentCell\"><table class=\"PParameters\"><tr><td class=\"PModifierQualifier first\">input uvme_layer_output#</td><td class=\"PType\">(amiq_eth_packet)&nbsp;</td><td class=\"PName last\">network_output</td></tr></table></td><td class=\"PAfterParameters\">)</td></tr></table></div><div class=\"TTSummary\">Get the downstream neighbour through a network_output</div></div>",211:"<div class=\"NDToolTip TFunction LSystemVerilog\"><div id=\"NDPrototype211\" class=\"NDPrototype WideForm CStyle\"><table><tr><td class=\"PBeforeParameters\"><span class=\"SHKeyword\">virtual function void</span> get_all_ds_neighours(</td><td class=\"PParametersParentCell\"><table class=\"PParameters\"><tr><td class=\"PModifierQualifier first\"><span class=\"SHKeyword\">ref</span>&nbsp;</td><td class=\"PType\">network_component&nbsp;</td><td class=\"PName last\">ds_neighbour[$]</td></tr></table></td><td class=\"PAfterParameters\">)</td></tr></table></div><div class=\"TTSummary\">Get all downstream neighbours through internal network_outputs network_switch should implement this function</div></div>",109:"<div class=\"NDToolTip TFunction LSystemVerilog\"><div id=\"NDPrototype109\" class=\"NDPrototype WideForm CStyle\"><table><tr><td class=\"PBeforeParameters\"><span class=\"SHKeyword\">virtual function</span> bit can_receive(</td><td class=\"PParametersParentCell\"><table class=\"PParameters\"><tr><td class=\"PType first\">amiq_eth_packet&nbsp;</td><td class=\"PName last\">txn</td></tr></table></td><td class=\"PAfterParameters\">)</td></tr></table></div><div class=\"TTSummary\">Does the packet can be received?</div></div>"});