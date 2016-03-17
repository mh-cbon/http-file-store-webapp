<mkdir>

    <form name="mkdir" onsubmit={mkdir} if={status!=='loading'}>
      <a href=#>+</a>
      <input type="text" name="name" placeholder="directory name" />
      <button>Create</button>
    </form>

  <style scoped>
  </style>

  <script>
    var tag = this;
    tag.status = 'loading'

    tag.items = [];
    tag.path = "";

    tag.on('mount', function(){
    });

    mkdir (e) {
      e.preventDefault();
      tag.trigger('new-dir', tag.path, this.name.value);
      this.name.value = '';
    }

  </script>

</mkdir>
