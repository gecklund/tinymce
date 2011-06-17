(function() {
	tinymce.create('tinymce.plugins.SourceFormat', {
		
	init : function(ed, url) {
		var t = this;
			
		ed.onGetContent.add(function(ed, o) {
			if(!o.source_view) return;
          
			var node = rootNode = new tinymce.html.DomParser().parse(o.content),
				tabCount = 0,
				newlineNode = new tinymce.html.Node('#text', 3),
				tabNode = new tinymce.html.Node('#text', 3),
				whiteSpaceRegEx = /^[ \t\r\n\s]*$/,
				tabVal = '  ',
				textVal, bWhiteSpace;
          
			newlineNode.value = '\n';
						
			//walk the tree
			while (node) {
				next = node.walk(node, rootNode);
				textVal = node.value;	
				bWhiteSpace = whiteSpaceRegEx.test(textVal);
				
				//if this is not the root node and not a whitespace text node
				if(node.parent && bWhiteSpace === false){
					
					//insert newline before this tag if its not a child of the root tag
					if(node.parent != rootNode || node.parent.firstChild != node)
						node.parent.insert(newlineNode.clone(), node, true);
					
					//insert newline after the tag if its not shortEnded
					if(!node.shortEnded)
						node.parent.insert(newlineNode.clone(), node);
											
					//if lastchild doesn't get a newline after it put one there
					  //this would be if its shortEnded or a whitespace text node
					if(node.lastChild && (node.lastChild.shortEnded || ( node.lastChild.type === 3 && whiteSpaceRegEx.test(node.lastChild.value)) ))
						node.append(newlineNode.clone());
					
					//count parents to figure out tabbing; there's probably a better way of doing this
					tabCount = t._countParents(node);
					
					if(tabCount > 0){
						tabNode.value = '';
						for(i = 0; i < tabCount; i++)
							tabNode.value = tabNode.value + tabVal;
						
						//insert tab before start tag
						node.parent.insert(tabNode.clone(), node, true);
						
						//insert tabs for the ending tag
						if(node.lastChild && !node.shortEnded)
							node.append(tabNode.clone());
					}
					
				}
								
				node = next;
			};
			
			o.content = new tinymce.html.Serializer().serialize(rootNode);
						
		});
	},

	getInfo : function() {
		return {
			longname : 'Source Formatter',
			author : 'Greg Ecklund',
			authorurl : '',
			infourl : '',
			version : tinymce.majorVersion + "." + tinymce.minorVersion
		};
	},

	// Private methods
	_countParents : function(node){
		var count = 0;
		while(node = node.parent){
			count++;
		}
		return count - 1;
	}
});

	// Register plugin
	tinymce.PluginManager.add('sourceformat', tinymce.plugins.SourceFormat);
})();