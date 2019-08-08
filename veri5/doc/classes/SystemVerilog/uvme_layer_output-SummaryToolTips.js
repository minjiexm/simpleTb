NDSummary.OnToolTipsLoaded("SystemVerilogClass:uvme_layer_output",{27:"<div class=\"NDToolTip TClass LSystemVerilog\"><div class=\"NDClassPrototype\" id=\"NDClassPrototype27\"><div class=\"CPEntry TClass Current\"><div class=\"CPName\">uvme_layer_output</div></div></div><div class=\"TTSummary\">layer output has two side.&nbsp; Inner side: inner side the the module\'s inner processiong. it will call output.send to send packets to the module\'s outside.</div></div>",117:"<div class=\"NDToolTip TFunction LSystemVerilog\"><div id=\"NDPrototype117\" class=\"NDPrototype WideForm CStyle\"><table><tr><td class=\"PBeforeParameters\"><span class=\"SHKeyword\">function new</span>(</td><td class=\"PParametersParentCell\"><table class=\"PParameters\"><tr><td class=\"PType first\"><span class=\"SHKeyword\">string</span>&nbsp;</td><td class=\"PName\">name&nbsp;</td><td class=\"PDefaultValueSeparator\">=&nbsp;</td><td class=\"PDefaultValue last\"><span class=\"SHString\">&quot;&quot;</span>,</td></tr><tr><td class=\"PType first\">uvm_component&nbsp;</td><td class=\"PName\">parent</td><td></td><td class=\"last\"></td></tr></table></td><td class=\"PAfterParameters\">)</td></tr></table></div><div class=\"TTSummary\">Constructor</div></div>",118:"<div class=\"NDToolTip TFunction LSystemVerilog\"><div id=\"NDPrototype118\" class=\"NDPrototype WideForm CStyle\"><table><tr><td class=\"PBeforeParameters\"><span class=\"SHKeyword\">virtual function void</span> build_phase(</td><td class=\"PParametersParentCell\"><table class=\"PParameters\"><tr><td class=\"PType first\">uvm_phase&nbsp;</td><td class=\"PName last\">phase</td></tr></table></td><td class=\"PAfterParameters\">)</td></tr></table></div><div class=\"TTSummary\">Standard uvm build_phase build driver and sequencer</div></div>",119:"<div class=\"NDToolTip TFunction LSystemVerilog\"><div id=\"NDPrototype119\" class=\"NDPrototype WideForm CStyle\"><table><tr><td class=\"PBeforeParameters\"><span class=\"SHKeyword\">virtual function void</span> connect_phase(</td><td class=\"PParametersParentCell\"><table class=\"PParameters\"><tr><td class=\"PType first\">uvm_phase&nbsp;</td><td class=\"PName last\">phase</td></tr></table></td><td class=\"PAfterParameters\">)</td></tr></table></div><div class=\"TTSummary\">Standard uvm connect_phase Connect put and get port to fifo</div></div>",215:"<div class=\"NDToolTip TFunction LSystemVerilog\"><div id=\"NDPrototype215\" class=\"NDPrototype WideForm CStyle\"><table><tr><td class=\"PBeforeParameters\"><span class=\"SHKeyword\">virtual</span> task send(</td><td class=\"PParametersParentCell\"><table class=\"PParameters\"><tr><td class=\"PType first\">T&nbsp;</td><td class=\"PName last\">txn</td></tr></table></td><td class=\"PAfterParameters\">)</td></tr></table></div><div class=\"TTSummary\">send data to output This is the blocking method to send data through output.</div></div>",121:"<div class=\"NDToolTip TFunction LSystemVerilog\"><div id=\"NDPrototype121\" class=\"NDPrototype WideForm CStyle\"><table><tr><td class=\"PBeforeParameters\"><span class=\"SHKeyword\">virtual</span> task run_phase(</td><td class=\"PParametersParentCell\"><table class=\"PParameters\"><tr><td class=\"PType first\">uvm_phase&nbsp;</td><td class=\"PName last\">phase</td></tr></table></td><td class=\"PAfterParameters\">)</td></tr></table></div><div class=\"TTSummary\">Uvm standard run_phase</div></div>",122:"<div class=\"NDToolTip TFunction LSystemVerilog\"><div id=\"NDPrototype122\" class=\"NDPrototype WideForm CStyle\"><table><tr><td class=\"PBeforeParameters\"><span class=\"SHKeyword\">virtual function void</span> link(</td><td class=\"PParametersParentCell\"><table class=\"PParameters\"><tr><td class=\"PType first\">this_input_type&nbsp;</td><td class=\"PName last\">neighbour_input</td></tr></table></td><td class=\"PAfterParameters\">)</td></tr></table></div><div class=\"TTSummary\">connect output to an input one output can only link to one input</div></div>",266:"<div class=\"NDToolTip TFunction LSystemVerilog\"><div id=\"NDPrototype266\" class=\"NDPrototype NoParameterForm\"><span class=\"SHKeyword\">virtual function</span> uvm_component get_connect_input()</div><div class=\"TTSummary\">Get connected uvm_layer_input</div></div>",124:"<div class=\"NDToolTip TFunction LSystemVerilog\"><div id=\"NDPrototype124\" class=\"NDPrototype WideForm CStyle\"><table><tr><td class=\"PBeforeParameters\"><span class=\"SHKeyword\">virtual function void</span> link_sequencer(</td><td class=\"PParametersParentCell\"><table class=\"PParameters\"><tr><td class=\"PModifierQualifier first\">uvm_sequencer#</td><td class=\"PType\">(T)&nbsp;</td><td class=\"PName last\">agent_seqr</td></tr></table></td><td class=\"PAfterParameters\">)</td></tr></table></div><div class=\"TTSummary\">connect the output to a real uvm_agent</div></div>",216:"<div class=\"NDToolTip TFunction LSystemVerilog\"><div id=\"NDPrototype216\" class=\"NDPrototype WideForm CStyle\"><table><tr><td class=\"PBeforeParameters\"><span class=\"SHKeyword\">virtual function void</span> inner_connect(</td><td class=\"PParametersParentCell\"><table class=\"PParameters\"><tr><td class=\"PModifierQualifier first\">uvm_analysis_port#</td><td class=\"PType\">(T)&nbsp;</td><td class=\"PName last\">monitor_ap</td></tr></table></td><td class=\"PAfterParameters\">)</td></tr></table></div><div class=\"TTSummary\">connect the output to agent monitor analysis_port.&nbsp; This function can only be called between analysis_port and output whose parents are the same one.&nbsp; This can be used for non-block write method to send data through output.</div></div>"});