tinymce.PluginManager.add("preview",function(a){var b=a.settings,c=!tinymce.Env.ie;a.addCommand("mcePreview",function(){a.windowManager.open({title:"Preview",width:parseInt(a.getParam("plugin_preview_width","650"),10),height:parseInt(a.getParam("plugin_preview_height","500"),10),html:'<iframe src="javascript:\'\'" frameborder="0"'+(c?' sandbox="allow-scripts"':"")+"></iframe>",buttons:{text:"Close",onclick:function(){this.parent().parent().close()}},onPostRender:function(){var d,e="";e+='<base href="'+a.documentBaseURI.getURI()+'">',tinymce.each(a.contentCSS,function(b){e+='<link type="text/css" rel="stylesheet" href="'+a.documentBaseURI.toAbsolute(b)+'">'});var f=b.body_id||"tinymce";-1!=f.indexOf("=")&&(f=a.getParam("body_id","","hash"),f=f[a.id]||f);var g=b.body_class||"";-1!=g.indexOf("=")&&(g=a.getParam("body_class","","hash"),g=g[a.id]||"");var h=a.settings.directionality?' dir="'+a.settings.directionality+'"':"";if(d="<!DOCTYPE html><html><head>"+e+'</head><body id="'+f+'" class="mce-content-body '+g+'"'+h+">"+a.getContent()+"</body></html>",c)this.getEl("body").firstChild.src="data:text/html;charset=utf-8,"+encodeURIComponent(d);else{var i=this.getEl("body").firstChild.contentWindow.document;i.open(),i.write(d),i.close()}}})}),a.addButton("preview",{title:"Preview",cmd:"mcePreview"}),a.addMenuItem("preview",{text:"Preview",cmd:"mcePreview",context:"view"})});