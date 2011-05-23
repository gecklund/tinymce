<!DOCTYPE html>
<html>
<head>
<title>Finalsite Tests</title>
<link rel="stylesheet" href="qunit/qunit.css" type="text/css" media="screen">
<script type="text/javascript" src="qunit/qunit.js"></script>
<script type="text/javascript" src="qunit/runner.js"></script>
<script type="text/javascript" src="js/utils.js"></script>
<script type="text/javascript" src="js/tiny_mce_loader.js"></script>
<script type="text/javascript" src="js/dsl/dsl.js"></script>
<script type="text/javascript" src="js/dsl/states.js"></script>
<script type="text/javascript" src="js/lists/actions.js"></script>

<script>
QUnit.config.autostart = false;

module('Finalsite', {
	autostart: false,
	setup: function() {
		window.queue = new dsl.Queue();
	}
});

// Tests
test('Preserving elements', function() {
	
	//style block
	editor.setContent('<style>.doNotStrip{ display:none; }</style>');
	equals(editor.getContent(), '<style><!--\n.doNotStrip{ display:none; }\n--></style>');
	
	//script block
	editor.setContent('<script>alert("Keep this!");</'+'script>');
	equals(editor.getContent(), '<script type="text/javascript">// <![CDATA[\nalert("Keep this!");\n// ]]></'+'script>');
	
	//dissappearing div bug cb:8396
	editor.setContent('<div class="imEmpty"></div>');
	equals(editor.getContent(), '<div class="imEmpty"></div>');
	
});

test('Media', function() {
	
	//writeFlash function cb:8376
	editor.setContent('<script language="Javascript" type="text/javascript">\nwriteFlash(\'uploaded/flash/photos.swf\',950,343,\'<img src="uploaded/templates/images/home/flash.jpg" width="950" height="343" />\');\n</'+'script>');
	equals(editor.getContent(), '<script type="text/javascript">// <![CDATA[\nwriteFlash(\'uploaded/flash/photos.swf\',950,343,\'<img src="uploaded/templates/images/home/flash.jpg" width="950" height="343" />\');\n// ]]></'+'script>');
	
});


initCallback = function(ed){
	editor = ed;

	ed.onNodeChange.addToTop(function() {
		return false;
	});

	QUnit.start();	
}

</script>

<cfset APPLICATION.cfcIncludeScript.addEditor(initCallback="initCallback") />
<cfoutput>#APPLICATION.cfcIncludeScript.output()#</cfoutput>

</head>
<body>
	<h1 id="qunit-header">Finalsite Test Cases</h1>
	<h2 id="qunit-banner"></h2>
	<div id="qunit-testrunner-toolbar"></div>
	<h2 id="qunit-userAgent"></h2>
	<ol id="qunit-tests"></ol>
	<div id="content">
		<textarea id="elm1" name="elm1"></textarea>
		<div>
			<a href="javascript:alert(tinymce.EditorManager.get('elm1').getContent({format : 'raw'}));">[getRawContents]</a>
			<a href="javascript:alert(tinymce.EditorManager.get('elm1').getContent());">[getContents]</a>
		</div>
	</div>
	
</body>
</html>
