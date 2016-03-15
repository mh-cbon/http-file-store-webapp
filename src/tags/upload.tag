<upload>
  <ul>
    <li each={item in items} style="width:{100/items.length}%;">
      <div class="progress" style="width:{item.completed}%;"></div>
      <div class="text">{item.name}</div>
    </li>
  </ul>


    <style scoped>
      :scope ul{
        list-style-type: none;
        height: 40px;
        margin:0;
        padding: 0;
      }
      :scope ul li{
        position: relative;
        height: 100%;
        display: inline-block;
      }
      :scope ul li .progress{
        background-color:green;
        position:absolute;
        top:0;
        left:0;
        height:100%;
        width:0%;
        z-index: 0;
      }
      :scope ul li .text{
        position:absolute;
        top:0;
        left:0;
        height:100%;
        width:100%;
        z-index: 1;
      }
    </style>

    <script>
      var tag = this;
      tag.items = [
        /*
        {
          name: 'some',
          completed: 30,
          total: 1212,
          loaded: 100
        }
        */
      ];

      tag.on('mount', function(){
      });

    </script>


</upload>
