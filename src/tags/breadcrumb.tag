<breadcrumb>

    <table if={status!=='loading'}>
      <tr>
          <td each={item, k in items}><a href=# onclick={itemClicked}>/{item || 'root'}</a></td>
      </tr>
    </table>

  <style scoped>
  </style>

  <script>
    var tag = this;
    tag.status = 'loading'

    tag.items = [];

    tag.on('mount', function(){
    });

    itemClicked (e) {
      e.preventDefault();
      var newPath = tag.path.split('/');
      newPath.pop()
      newPath = newPath.slice(0, parseInt(e.item.k)+1).join('/');
      tag.trigger('browse-to', newPath + '/')
    }

  </script>

</breadcrumb>
