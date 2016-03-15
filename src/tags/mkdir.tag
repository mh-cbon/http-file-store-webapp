<mkdir>

    <form name="mkdir" onsubmit={mkdir}>
      <a href=#>+</a>
      <input type="text" name="name" placeholder="directory name" />
      <button>Create</button>
    </form>

  <style scoped>
  </style>

  <script>
    var tag = this;

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
