
var riot = require('riot');
var path = require('path');

require('./tags/file-browser.tag');
require('./tags/mkdir.tag');
require('./tags/breadcrumb.tag');
require('./tags/upload.tag');
require('./tags/alert.tag');
var FSClient = require('@mh-cbon/http-file-store/client.js');

document.addEventListener('DOMContentLoaded', function () {

  var app = riot.observable();

  var client = new FSClient({
    protocol: 'http:',
    hostname: '127.0.0.1',
    port: 8091,
    url_base: ''
  });
  var browser     = riot.mount('file-browser', {})[0];
  var breadcrumb  = riot.mount('breadcrumb', {})[0];
  var upload      = riot.mount('upload', {})[0];
  var mkdir       = riot.mount('mkdir', {})[0];
  var alert       = riot.mount('alert', {})[0];

  app.on('path-changed', function (newPath) {

    [browser, mkdir, breadcrumb].forEach(function (c) {
      c.status = 'loading'
    })

    client.read(newPath, function (err, res) {

      [browser, mkdir, breadcrumb].forEach(function (c) {
        c.status = 'loaded'
        c.update();
      })

      if (err) return itFailedToBrowse();

      browser.path    = newPath;
      browser.items   = res;
      browser.endPointUrl = client.endPointUrl();

      mkdir.path    = newPath;

      breadcrumb.path   = newPath;
      breadcrumb.items  = newPath.split('/');
      breadcrumb.items.pop();

      [browser, mkdir, breadcrumb].forEach(function (c) {
        c.path    = newPath;
        c.update();
      })
    });
  });

  app.trigger('path-changed', '/');

  mkdir.on('new-dir', function (targetPath, name) {
    client.mkdir(targetPath, name, function (err, data) {
      if (err) {
        return itFailedToCreateADirectory();
      }
      browser.items = data;
      browser.update();
    })
  })

  breadcrumb.on('browse-to', function (p) {
    app.trigger('path-changed', p);
  });

  browser.on('browse-to', function (p) {
    app.trigger('path-changed', p);
  });
  browser.on('browse-file', function (fileName) {
    window.open(client.endPointUrl(browser.path + fileName, { download: 1 }));
  });
  browser.on('browse-up', function (p) {
    var newPath = path.resolve(browser.path, '..');
    newPath = newPath !== '/' ? newPath + '/' : newPath;
    app.trigger('path-changed', newPath);
  });
  browser.on('delete-some', function (targetPath) {
    client.unlink(targetPath,  true, function (err, data) { // @todo add recursive UI option
      if (err) return itFailedToDelete();
      browser.items = data;
      browser.update();
    });
  })
  browser.on('upload', function (targetPath, file) {
    enqueueFileForUpload(targetPath, file, false, function (err, data){
      if (err) {
        wouldYouLikeToOverwrite(function (res) {
          if (res) {
            enqueueFileForUpload(targetPath, file, true, function (errOverwrite, data){
              if (errOverwrite) {
                itFailedToWrite(); // trigger alert such nothing can be done.
              } else if (targetPath===browser.path){
                browser.items = data;
                browser.update();
              }
            })
          }
        });
      } else if (targetPath===browser.path){
        browser.items = data;
        browser.update();
      }
    })
  });

  function wouldYouLikeToOverwrite(then){
    alert.title = 'Can not write the file'
    alert.question = 'The file already exists, would you like to overwrite it ?'
    alert.choices = [
      {
        label: 'yes',
        value: true
      },
      {
        label: 'no',
        value: false
      }
    ]
    alert.show(then)
  }

  function itFailedToBrowse(then){
    alert.title = 'Can not browse the path'
    alert.question = 'The new path can not be browsed, please alert your admin.'
    alert.choices = [
      {
        label: 'OK',
        value: true
      }
    ]
    alert.show(then)
  }

  function itFailedToCreateADirectory(then){
    alert.title = 'Can create this directory'
    alert.question = 'The directory was not created, please alert your admin.'
    alert.choices = [
      {
        label: 'OK',
        value: true
      }
    ]
    alert.show(then)
  }

  function itFailedToWrite(then){
    alert.title = 'Can not write the file'
    alert.question = 'The file was not written successfully, please alert your admin.'
    alert.choices = [
      {
        label: 'OK',
        value: true
      }
    ]
    alert.show(then)
  }

  function itFailedToDelete(then){
    alert.title = 'Can not delete the file'
    alert.question = 'The file was not deleted successfully, please alert your admin.'
    alert.choices = [
      {
        label: 'OK',
        value: true
      }
    ]
    alert.show(then)
  }

  function enqueueFileForUpload (targetPath, file, overwrite, then) {
    var handle = overwrite ? client.overwrite : client.write;

      var progress = handle(targetPath, file.data, then);
      var item = {
        completed: 0,
        name: file.name
      };
      progress.on('start', function () {
        upload.items.push(item);
        upload.update();
      });
      progress.on('progress', function (e) {
        item.loaded     = e.loaded;
        item.total      = e.total;
        item.completed  = e.loaded / e.total * 100;
        upload.update();
      });
      progress.on('end', function () {
        var index = upload.items.indexOf(item);
        upload.items.splice(index, 1)
        upload.update();
      });
  }
});
