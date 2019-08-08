NDSummary.OnToolTipsLoaded("File:uvme-1.0/src/agent/uvme_agent.svh",{48:"<div class=\"NDToolTip TClass LSystemVerilog\"><div class=\"NDClassPrototype\" id=\"NDClassPrototype48\"><div class=\"CPEntry TClass Current\"><div class=\"CPName\">uvme_agent_config</div></div></div><div class=\"TTSummary\">The uvme_agent_config class is the configuration class for uvme_agent.&nbsp; Used to control active/passive mode and whether enable function coverage.&nbsp; User should extend from this class.</div></div>",143:"<div class=\"NDToolTip TFunction LSystemVerilog\"><div id=\"NDPrototype143\" class=\"NDPrototype WideForm CStyle\"><table><tr><td class=\"PBeforeParameters\"><span class=\"SHKeyword\">function new</span> (</td><td class=\"PParametersParentCell\"><table class=\"PParameters\"><tr><td class=\"PType first\"><span class=\"SHKeyword\">string</span>&nbsp;</td><td class=\"PName\">name&nbsp;</td><td class=\"PDefaultValueSeparator\">=&nbsp;</td><td class=\"PDefaultValue last\"><span class=\"SHString\">&quot;uvme_agent_config&quot;</span></td></tr></table></td><td class=\"PAfterParameters\">)</td></tr></table></div><div class=\"TTSummary\">Constructor</div></div>",144:"<div class=\"NDToolTip TClass LSystemVerilog\"><div class=\"NDClassPrototype\" id=\"NDClassPrototype144\"><div class=\"CPEntry TClass Current\"><div class=\"CPName\">uvme_coverage</div></div></div><div class=\"TTSummary\">The uvme_coverage class is the class where user should implement function function coverage sample.</div></div>",146:"<div class=\"NDToolTip TFunction LSystemVerilog\"><div id=\"NDPrototype146\" class=\"NDPrototype WideForm CStyle\"><table><tr><td class=\"PBeforeParameters\"><span class=\"SHKeyword\">function new</span> (</td><td class=\"PParametersParentCell\"><table class=\"PParameters\"><tr><td class=\"PType first\"><span class=\"SHKeyword\">string</span>&nbsp;</td><td class=\"PName\">name&nbsp;</td><td class=\"PDefaultValueSeparator\">=&nbsp;</td><td class=\"PDefaultValue last\"><span class=\"SHString\">&quot;uvme_coverage&quot;</span>,</td></tr><tr><td class=\"PType first\">uvm_component&nbsp;</td><td class=\"PName\">parent&nbsp;</td><td class=\"PDefaultValueSeparator\">=&nbsp;</td><td class=\"PDefaultValue last\"><span class=\"SHKeyword\">null</span></td></tr></table></td><td class=\"PAfterParameters\">)</td></tr></table></div><div class=\"TTSummary\">Constructor</div></div>",147:"<div class=\"NDToolTip TFunction LSystemVerilog\"><div id=\"NDPrototype147\" class=\"NDPrototype WideForm CStyle\"><table><tr><td class=\"PBeforeParameters\"><span class=\"SHKeyword\">virtual function void</span> write(</td><td class=\"PParametersParentCell\"><table class=\"PParameters\"><tr><td class=\"PType first\">T&nbsp;</td><td class=\"PName last\">t</td></tr></table></td><td class=\"PAfterParameters\">)</td></tr></table></div><div class=\"TTSummary\">Convert Write function to this.collect_func_cov</div></div>",148:"<div class=\"NDToolTip TFunction LSystemVerilog\"><div id=\"NDPrototype148\" class=\"NDPrototype WideForm CStyle\"><table><tr><td class=\"PBeforeParameters\"><span class=\"SHKeyword\">virtual function void</span> collect_func_cov(</td><td class=\"PParametersParentCell\"><table class=\"PParameters\"><tr><td class=\"PType first\">T&nbsp;</td><td class=\"PName last\">tr</td></tr></table></td><td class=\"PAfterParameters\">)</td></tr></table></div><div class=\"TTSummary\">Collect function coverage</div></div>",149:"<div class=\"NDToolTip TClass LSystemVerilog\"><div class=\"NDClassPrototype\" id=\"NDClassPrototype149\"><div class=\"CPEntry TClass Current\"><div class=\"CPName\">uvme_monitor</div></div></div><div class=\"TTSummary\">The uvme_monitor class add a analysis port in order to send the trancaction received by monitor out to coverage or other components.</div></div>",151:"<div class=\"NDToolTip TFunction LSystemVerilog\"><div id=\"NDPrototype151\" class=\"NDPrototype WideForm CStyle\"><table><tr><td class=\"PBeforeParameters\"><span class=\"SHKeyword\">function new</span> (</td><td class=\"PParametersParentCell\"><table class=\"PParameters\"><tr><td class=\"PType first\"><span class=\"SHKeyword\">string</span>&nbsp;</td><td class=\"PName\">name&nbsp;</td><td class=\"PDefaultValueSeparator\">=&nbsp;</td><td class=\"PDefaultValue last\"><span class=\"SHString\">&quot;uvme_monitor&quot;</span>,</td></tr><tr><td class=\"PType first\">uvm_component&nbsp;</td><td class=\"PName\">parent&nbsp;</td><td class=\"PDefaultValueSeparator\">=&nbsp;</td><td class=\"PDefaultValue last\"><span class=\"SHKeyword\">null</span></td></tr></table></td><td class=\"PAfterParameters\">)</td></tr></table></div><div class=\"TTSummary\">Constructor</div></div>",152:"<div class=\"NDToolTip TFunction LSystemVerilog\"><div id=\"NDPrototype152\" class=\"NDPrototype WideForm CStyle\"><table><tr><td class=\"PBeforeParameters\"><span class=\"SHKeyword\">virtual function void</span> build_phase(</td><td class=\"PParametersParentCell\"><table class=\"PParameters\"><tr><td class=\"PType first\">uvm_phase&nbsp;</td><td class=\"PName last\">phase</td></tr></table></td><td class=\"PAfterParameters\">)</td></tr></table></div><div class=\"TTSummary\">Standard UVM build_phase</div></div>",153:"<div class=\"NDToolTip TClass LSystemVerilog\"><div class=\"NDClassPrototype\" id=\"NDClassPrototype153\"><div class=\"CPEntry TClass Current\"><div class=\"CPName\">uvme_driver</div></div></div><div class=\"TTSummary\">The uvme_driver class is the same as uvm_driver.&nbsp; Just allow user can use factory overwrite to change the type of driver.</div></div>",155:"<div class=\"NDToolTip TFunction LSystemVerilog\"><div id=\"NDPrototype155\" class=\"NDPrototype WideForm CStyle\"><table><tr><td class=\"PBeforeParameters\"><span class=\"SHKeyword\">function new</span> (</td><td class=\"PParametersParentCell\"><table class=\"PParameters\"><tr><td class=\"PType first\"><span class=\"SHKeyword\">string</span>&nbsp;</td><td class=\"PName\">name&nbsp;</td><td class=\"PDefaultValueSeparator\">=&nbsp;</td><td class=\"PDefaultValue last\"><span class=\"SHString\">&quot;uvme_driver&quot;</span>,</td></tr><tr><td class=\"PType first\">uvm_component&nbsp;</td><td class=\"PName\">parent&nbsp;</td><td class=\"PDefaultValueSeparator\">=&nbsp;</td><td class=\"PDefaultValue last\"><span class=\"SHKeyword\">null</span></td></tr></table></td><td class=\"PAfterParameters\">)</td></tr></table></div><div class=\"TTSummary\">Constructor</div></div>",156:"<div class=\"NDToolTip TClass LSystemVerilog\"><div class=\"NDClassPrototype\" id=\"NDClassPrototype156\"><div class=\"CPEntry TClass Current\"><div class=\"CPName\">uvme_agent</div></div></div><div class=\"TTSummary\">The uvme_agent class is an agent type which will driver data to DUT and receive data from DUT.</div></div>",157:"<div class=\"NDToolTip TFunction LSystemVerilog\"><div id=\"NDPrototype157\" class=\"NDPrototype WideForm CStyle\"><table><tr><td class=\"PBeforeParameters\"><span class=\"SHKeyword\">function new</span>(</td><td class=\"PParametersParentCell\"><table class=\"PParameters\"><tr><td class=\"PType first\"><span class=\"SHKeyword\">string</span>&nbsp;</td><td class=\"PName last\">name,</td></tr><tr><td class=\"PType first\">uvm_component&nbsp;</td><td class=\"PName last\">parent</td></tr></table></td><td class=\"PAfterParameters\">)</td></tr></table></div><div class=\"TTSummary\">Constructor</div></div>",158:"<div class=\"NDToolTip TFunction LSystemVerilog\"><div id=\"NDPrototype158\" class=\"NDPrototype WideForm CStyle\"><table><tr><td class=\"PBeforeParameters\"><span class=\"SHKeyword\">virtual function void</span> build_phase(</td><td class=\"PParametersParentCell\"><table class=\"PParameters\"><tr><td class=\"PType first\">uvm_phase&nbsp;</td><td class=\"PName last\">phase</td></tr></table></td><td class=\"PAfterParameters\">)</td></tr></table></div><div class=\"TTSummary\">build_phase</div></div>",159:"<div class=\"NDToolTip TFunction LSystemVerilog\"><div id=\"NDPrototype159\" class=\"NDPrototype WideForm CStyle\"><table><tr><td class=\"PBeforeParameters\"><span class=\"SHKeyword\">virtual function void</span> connect_phase(</td><td class=\"PParametersParentCell\"><table class=\"PParameters\"><tr><td class=\"PType first\">uvm_phase&nbsp;</td><td class=\"PName last\">phase</td></tr></table></td><td class=\"PAfterParameters\">)</td></tr></table></div><div class=\"TTSummary\">connect_phase</div></div>"});