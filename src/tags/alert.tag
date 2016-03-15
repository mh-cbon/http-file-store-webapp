<alert>

  <div class="alert" if={display}>
    <div class="background"></div>
    <div class="front">
      <div class="title">{title}</div>
      <div class="question">{question}</div>
      <div class="confirm">
        <ul>
          <li each={choice in choices}><button onclick={choiceClicked}>{choice.label}</button></li>
        </ul>
      </div>
    </div>
  </div>

  <style scoped>
  :scope .alert {
    position: fixed;
    top:0;left:0;
    height:100%;
    width:100%;
    z-index:100;
  }
  :scope .background {
    position: absolute;
    top:0;left:0;
    height:100%;
    width:100%;
    background-color:black;
    opacity:0.7;
  }
  :scope .front {
    position: absolute;
    top:25%;
    left:25%;
    height:50%;
    width:50%;
    background-color: white;
    padding: .5em;
  }
  :scope .title {
    text-transform:uppercase;
  }
  :scope .question {
    margin-top: 1em;
    margin-left: 1em;
  }
  :scope .confirm ul {
    position: absolute;
    bottom: 0.5em;
    right: 0.5em;
    display:block;
  }
  :scope .confirm ul {
    margin:0;
    padding:0;
    list-style-type:none;
  }
  :scope .confirm ul li {
    display: inline-block;
    margin-right: .5em;
  }
  </style>

  <script>
    var tag = this;
    tag.display = !true
    tag.title = ''
    tag.question = ''
    tag.choices = [
      /*
      {
        label: 'yes',
        value: true
      }
      */
    ]
    var pendingCb;

    tag.on('mount', function(){
    });

    choiceClicked (e) {
      e.preventDefault();
      tag.display = false;
      console.log(e.item)
      if (pendingCb) pendingCb(e.item.choice.value);
      pendingCb = null;
      tag.update();
    }

    show (then) {
      tag.display = true;
      pendingCb = then;
      tag.update();
    }

  </script>

</alert>
