NDSummary.OnToolTipsLoaded("SystemVerilogClass:uvme_analysis_callback",{84:"<div class=\"NDToolTip TClass LSystemVerilog\"><div class=\"NDClassPrototype\" id=\"NDClassPrototype84\"><div class=\"CPEntry TClass Current\"><div class=\"CPName\">uvme_analysis_callback</div></div></div><div class=\"TTSummary\">The uvme_analysis_callback class is the callback class used to some modify or even drop the transactions with out change the inerr codes of model.</div></div>",207:"<div class=\"NDToolTip TFunction LSystemVerilog\"><div id=\"NDPrototype207\" class=\"NDPrototype WideForm CStyle\"><table><tr><td class=\"PBeforeParameters\"><span class=\"SHKeyword\">function new</span> (</td><td class=\"PParametersParentCell\"><table class=\"PParameters\"><tr><td class=\"PType first\"><span class=\"SHKeyword\">string</span>&nbsp;</td><td class=\"PName\">name&nbsp;</td><td class=\"PDefaultValueSeparator\">=&nbsp;</td><td class=\"PDefaultValue last\"><span class=\"SHString\">&quot;trans&quot;</span></td></tr></table></td><td class=\"PAfterParameters\">)</td></tr></table></div><div class=\"TTSummary\">Construction</div></div>",208:"<div class=\"NDToolTip TFunction LSystemVerilog\"><div id=\"NDPrototype208\" class=\"NDPrototype WideForm CStyle\"><table><tr><td class=\"PBeforeParameters\"><span class=\"SHKeyword\">virtual function void</span> receive_cbF(</td><td class=\"PParametersParentCell\"><table class=\"PParameters\"><tr><td class=\"PType first\">T&nbsp;</td><td class=\"PName last\">txn</td></tr></table></td><td class=\"PAfterParameters\">)</td></tr></table></div><div class=\"TTSummary\">callback function for analysis_input Use to get data</div></div>",209:"<div class=\"NDToolTip TFunction LSystemVerilog\"><div id=\"NDPrototype209\" class=\"NDPrototype WideForm CStyle\"><table><tr><td class=\"PBeforeParameters\"><span class=\"SHKeyword\">virtual function void</span> send_cbF(</td><td class=\"PParametersParentCell\"><table class=\"PParameters\"><tr><td class=\"PType first\">T&nbsp;</td><td class=\"PName last\">txn</td></tr></table></td><td class=\"PAfterParameters\">)</td></tr></table></div><div class=\"TTSummary\">callback function for analysis_output</div></div>",210:"<div class=\"NDToolTip TFunction LSystemVerilog\"><div id=\"NDPrototype210\" class=\"NDPrototype WideForm CStyle\"><table><tr><td class=\"PBeforeParameters\"><span class=\"SHKeyword\">virtual function void</span> error_inject_cbF(</td><td class=\"PParametersParentCell\"><table class=\"PParameters\"><tr><td class=\"first\"></td><td class=\"PType\">T&nbsp;</td><td class=\"PName last\">txn,</td></tr><tr><td class=\"PModifierQualifier first\">output&nbsp;</td><td class=\"PType\">uvme_ei_enum&nbsp;</td><td class=\"PName last\">ei</td></tr></table></td><td class=\"PAfterParameters\">)</td></tr></table></div><div class=\"TTSummary\">callback function for error_injection like drop or modify packet</div></div>"});