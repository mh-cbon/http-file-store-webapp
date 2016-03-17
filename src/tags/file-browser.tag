<file-browser>

    <div if={status==='loading'}>
      Please wait while loading....
    </div>

    <table
        if={status!=='loading'}
        ondragenter={dragEnter}
        ondragleave={dragLeave}
        ondragover={dragOver}
        ondrop={drop}>
      <tr>
          <td>
            <a href="#" onclick={itemClicked}>..</a>
          </td>
          <td>&nbsp;</td>
      </tr>
      <tr each={items}>
          <td class="type-{type}"
              ondragenter={dragEnter}
              ondragleave={dragLeave}
              ondragover={dragOver}
              ondrop={drop}><a href="{path}{name}" onclick={itemClicked}>{name}</a></td>
          <td><a href=# onclick={unlinkItem}>X</a></td>
      </tr>
    </table>


  <style scoped>
  :scope .drag-over {
    background-color: blue;
  }
  </style>

  <script>
    var dropNormalizer = require('../drop-normalizer.js')
    var tag = this;
    tag.status = 'loading'

    tag.items = [];
    tag.endPointUrl = '';
    tag.path = '';

    tag.on('mount', function(){
    });

    itemClicked (e) {
      e.preventDefault();
      e.stopPropagation();
      if(!e.item) {
        tag.trigger('browse-up')
      } else if(e.item.type==='file'){
        tag.trigger('browse-file', e.item.name)
      } else if (e.item.type==='dir' || e.item.type==='alias') {
        tag.trigger('browse-to', tag.path + '' + e.item.name + '/')
      }
    }

    unlinkItem (e) {
      e.preventDefault();
      tag.trigger('delete-some', tag.path + '' + e.item.name)
    }

    // dragStart(e) {console.log('dragStart ' + e.item.type);}
    var removeClassNames = function (el, which) {
      which = which || /\s*(drag-enter|drag-over|drag-leave|drop)\s*/g;
      el.className = el.className.replace(which, " ");
    }

    dragEnter(e) {
      e.preventDefault();
      e.stopPropagation();
      var el = e.currentTarget;
      if (!e.item || e.item.type.match(/dir|alias/)) {
        removeClassNames(el);
        el.className += " drag-enter";
      }
    }
    dragLeave(e) {
      e.preventDefault();
      e.stopPropagation();
      var el = e.currentTarget;
      if (!e.item || e.item.type.match(/dir|alias/)) {
        removeClassNames(el);
        el.className += " drag-leave";
        setTimeout(function (){
          removeClassNames(el, /\s*drag-leave\s*/g);
        }, 500);
      }
    }
    dragOver(e) {
      e.preventDefault();
      e.stopPropagation();
      var el = e.currentTarget;
      if (!e.item || e.item.type.match(/dir|alias/)) {
        removeClassNames(el);
        el.className += " drag-over";
      }
    }
    drop(e) {
      e.preventDefault();
      e.stopPropagation();
      var el = e.currentTarget;
      if (!e.item || e.item.type.match(/dir|alias/)) {
        removeClassNames(el);
        el.className += " drop";
        setTimeout(function (){
          removeClassNames(el);
        }, 500);

        var targetPath = tag.path;
        if (e.item) targetPath += '' + e.item.name;
        items = dropNormalizer.normalize(e.dataTransfer);
        console.log(items);
        items.forEach(function (item) {
          tag.trigger('upload', targetPath, item)
        })

      }
    }

  </script>

</file-browser>
