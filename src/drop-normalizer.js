/*
html5 drag and drop interface is real shit, sorry guys.

This helper can help us to deal with that, a little bit, it s shit too.

pass in the ev.dataTransfer to get a more convenient array

normalizer.normalize(ev.dataTransfer)

Does not handle directory properly....
Does handle url, and file drop, i hope correctly for ff / chrome.
*/

var dropNormalizer = {
  isAboutUrl: function (dataTransfer) {
    var types = dataTransfer.types;
    var files = dataTransfer.files;
    if (files.length) return false;
    for (var i = 0; i<types.length; i++) {
      if (types[i].match(/uri-list|x-moz-url/)) {
        return true;
      }
    }
    return false;
  },
  isAboutFile: function (dataTransfer) {
    var types = dataTransfer.types;
    var files = dataTransfer.files;
    if (!files.length) return false;
    for (var i = 0; i<types.length; i++) {
      if (types[i].match(/Files/)) {
        return true;
      }
    }
    return false;
  },
  normalize: function (dataTransfer) {
    var res = [];
    if(dropNormalizer.isAboutUrl(dataTransfer) && !dropNormalizer.isAboutFile(dataTransfer)) {
      res.push({
        type: 'text/uri-list',
        data: dataTransfer.getData('Text')
      });
    } else if (dropNormalizer.isAboutFile(dataTransfer)) {
      var fullPaths = dataTransfer.getData('Text').split('\n');
      var files = dataTransfer.files;
      for (var i = 0; i<files.length; i++) {
        console.log(files[i]);
        res.push({
          type: 'file',
          name: files[i].name,
          data: files[i],
          path: fullPaths[i]
        });
      }
    } else {
      res.push({
        type: 'text/plain',
        data: dataTransfer.getData('Text')
      });
    }

    return res;
  }
};

module.exports = dropNormalizer;
