/**
 * @author    GRUPO 1 <wat2022.wordpress.com>
 **/

//Eventos
document.getElementById("editar").addEventListener("click",edit);
document.getElementById("contraseniaBtn").addEventListener("click", mostrarMenu);
document.getElementById("contra2").addEventListener("focusout", matchPassword);
document.getElementById("nombre").addEventListener("focusout", validarNombre);
document.getElementById("apellidos").addEventListener("focusout", validarApellidos);
document.getElementById("email").addEventListener("focusout", validarEmail);
document.getElementById('foto').addEventListener('change', handleFileSelect, false);
document.getElementById('his').addEventListener("click",verHistorial);

//Funcion que activa el boton de editar perfil:
function edit() {
    let inputs = document.getElementsByClassName("inputs");
    for (let x = 0; x < inputs.length; x++) {
        inputs[x].disabled = false;
    }
}
//Funcion que muestra una ventana dentro del propio boton de cambiar contraseña en el apartado de editar el perfil:
function mostrarMenu(){
    let menu = document.getElementById("cambiarPASS");
    menu.classList.toggle("shown");
}
//Funcion que comprueba si el cambio de contraseñas se realiza correctamente:
function matchPassword(){
    let pass1 = document.getElementById("contra1").value;
    let pass2 = document.getElementById("contra2").value;
    if(pass1 != pass2){	
        document.getElementById("passIncorrecta").hidden = false;
    } else {
        document.getElementById("passIncorrecta").hidden = true;
    }
}
//Funcion que valida el nombre:
function validarNombre() {
    let nom = document.getElementById('nombre').value;
    let exRegName  =  new RegExp (/^[A-Z]{1}[a-z]+$/);
    if (!exRegName.test(nom)){
        document.getElementById("nombre").focus();
        document.getElementById("nombreIncorrecto").hidden = false;
    } else {
        document.getElementById("nombreIncorrecto").hidden = true;
    }
}
//Funcion que valida los apellidos:
function validarApellidos() {
    let apellido = document.getElementById('apellidos').value;
    let exRegName  =  new RegExp (/^[A-Z]{1}[a-z]+$/);
    if (!exRegName.test(apellido)){
        document.getElementById("apellidos").focus();
        document.getElementById("apellidosIncorrectos").hidden = false;
    } else {
        document.getElementById("apellidosIncorrectos").hidden = true;
    }
}
//Funcion que valida el email:
function validarEmail() {
    let email = document.getElementById('email').value;
    let exRegEmail =  new RegExp ('^[_a-z0-9-]+(.[_a-z0-9-]+)*@[a-z0-9-]+(.[a-z0-9-]+)*(.[a-z]{2,4})$');
    if (!exRegEmail.test(email)){
        document.getElementById("email").focus();
        document.getElementById("emailIncorrecto").hidden = false;
    } else {
        document.getElementById("emailIncorrecto").hidden = true;
    }
}

/* GUARDAR LA IMAGEN EN LOCALSTORAGE */
function handleFileSelect(evt) {
    
    var files = evt.target.files; // FileList object
    localStorage.removeItem('img'); // Para que no hayan 2 imagenes

    //Obtiene la FileList y renderiza los archivos de imagen como miniaturas.
    for (var i = 0, f; f = files[i]; i++) {

      // Solo procesa imagenes.
      if (!f.type.match('image.*')) {
        continue;
      }

      var reader = new FileReader();

      // Cierre para capturar la información del archivo.
      reader.onload = (function(theFile) {
        return function(e) {
          // Creamos un span con la imagen
          var span = document.createElement('span');
          span.innerHTML = ['<img id="fperfilnueva" class="perfil" src="', e.target.result,
            '"/>'
          ].join('');

          document.getElementById('list').insertBefore(span, null);
          localStorage.setItem('img', e.target.result);
        };
      })(f);

      // Lee el archivo de imagen como una URL de datos.
      reader.readAsDataURL(f);
      document.getElementById('fotoperfil').hidden = true;
    }
  }

  // Si tenenemos una imagen en LocalStorage...
  if (localStorage.img) {
    var span = document.createElement('span');
    span.innerHTML += ['<img class="perfil" src="', localStorage.img,
      '"/>'
    ].join('');

    document.getElementById('list').insertBefore(span, null);
  } else {
    // Ocultamos la imagen por defecto del usuario
    document.getElementById('fotoperfil').hidden = false;
  }

const API_URL = '/PHP/API_get.php';
async function cargarPreguntasUsuario(id_usuario) {
  let respuesta = await fetch(API_URL + '?funcion=getPreguntasUsuario&id=' + id_usuario) // con '?' separamos la ruta de los parametros
                      /*El await espera al resultado de la promesa que devuelve la funcion asincrona*/
 
  if (respuesta.ok) {
      return respuesta.json();
  } else {
      return {
          mensaje: 'Error en el servidor',
      };
  }
}
//Funcion para valorar:
function setValoracion(valoracion,num) {
  if (valoracion == num) {
      return "checked";
  } else return "";
}
//Funcion para cargar el layout:
function cargarLayoutPregunta(datosPregunta) {
  let contenedorPregunta = document.getElementsByClassName("historial-preguntas")[0];
  let pregunta = document.createElement('div');
  pregunta.classList.add('pregunta');
  pregunta.classList.add('recuadro');

  pregunta.innerHTML = `<div class='user'>
  <h2 class='titulousuario' id='titulousuario'>${datosPregunta.usuario}</h2>
  <img class='perfil' src='../RECURSOS/IMAGES/user.png' alt='Foto de perfil'>
  <form>
  <p class='clasificacion'>
      <input id='radio1' type='radio' name='estrellas' value='5' disabled ${setValoracion(datosPregunta.valoracion,5)}>
      <label for='radio1'>★</label>
      <input id='radio2' type='radio' name='estrellas' value='4' disabled ${setValoracion(datosPregunta.valoracion,4)}>
      <label for='radio2'>★</label>
      <input id='radio3' type='radio' name='estrellas' value='3' disabled ${setValoracion(datosPregunta.valoracion,3)}>
      <label for='radio3'>★</label>
      <input id='radio4' type='radio' name='estrellas' value='2' disabled ${setValoracion(datosPregunta.valoracion,2)}>
      <label for='radio4'>★</label>
      <input id='radio5' type='radio' name='estrellas' value='1' disabled ${setValoracion(datosPregunta.valoracion,1)}>
      <label for='radio5'>★</label>
  </p>
</form>
</div>
<div class='info'>
  <h2>${datosPregunta.titulo}</h2> <br>
  <p id='usuario'><b>Usuario:</b>${datosPregunta.usuario} </p>
  <p id='fecha'><b>Fecha:</b> ${datosPregunta.fecha}</p>
  <p id='departamento'><b>Departamento:</b> ${datosPregunta.categoria}</p>
</div>
<div class='atributos'>
    <div class='stats'>
        <div class='iconos'>
            <i class='fa-solid fa-thumbs-up'></i>
            <br>
            <b class='nums'>${datosPregunta.likes}</b>
            <b>LIKE</b>
        </div>
        <div class='iconos'>
            <i class='fa-brands fa-teamspeak'></i>
            <br>
            <b class='nums'>${datosPregunta.respuestas}</b>
            <b>RES</b>
        </div>
        <div class='iconos'>
            <i class='fa-solid fa-eye'></i>
            <br>
            <b class='nums'>${datosPregunta.vistos}</b>
            <b>VISTO</b>
        </div>
    </div>
    <br>
    <a class='res' href='?accion=detalles' onclick=\"actualizarVisto('${datosPregunta.id_preg}')\">Detalle</a>
</div>`;

  //Obtenemos el boton para añadir un evento click
  let respuestasBoton = pregunta.getElementsByClassName('res')[0];
  respuestasBoton.addEventListener('click', (e) => {
  //Establece el id_preg dentro del localStorage
  //Obtenemos datosPregunta de la API y obtenemos el id de la pregunta
      localStorage.setItem("idPregunta", datosPregunta.id_preg);
  });

  contenedorPregunta.appendChild(pregunta);
}

//Mostrar historial con IndexedDB.Es una manera de almacenar datos de manera persistente en el navegador

/*Creamos la base de datos a través del objeto indexedDB*/
let db;
const indexedDB = window.indexedDB; //desciende del objeto window
if(indexedDB){

  // borrar la base de datos para volver a solicitar la informacion
  indexedDB.deleteDatabase('historial');
  //Almacena la base de datos y recibe dos paramentros, el nombre y la version , respectivamente
  const request = indexedDB.open('historial',1);
  //Métodos asíncronos:
  request.onsuccess=()=>{
    db = request.result;
    console.log('OPEN',db);

    //Cargar los datos si no existen:
    cargarPreguntasUsuario(getCookie('Nombre')).then((listaPreguntas) => {
      /*
      Todas las operaciones sobre una base de datos indexada funcionan a través de una transacción:
      Recibe dos parametros,el almacen dónde vamos a trabajar y el modo, en este caso lectura y escritura.
      */
      const transaction = db.transaction('historial','readwrite');
      const objectStore = transaction.objectStore('historial');
      //Iteramos la pregunta y la añadimos a nuestro objeto:
      for (let pregunta of listaPreguntas) {
        objectStore.add(pregunta);
      }
      transaction.commit();//confirma la transacción si se llama en una transacción activa.
    });
  }
  /*Comprobamos si la base de datos existe o tiene que ser creada a través del método onupgradeneeded()*/
  request.onupgradeneeded=()=>{
    db = request.result;
    console.log('CREATE',db);
    /*Crear almacén de objetos con el método crearObjectStorage()*/
    const objectStore = db.createObjectStore('historial', {
      //devuelve la ruta clave de este almacén de objetos.
      keyPath: 'id_preg'
    });
  }
  //Si no funciona :
  request.onerror=(error)=>{
     console.log('ERROR',error);
  }

}
//Funcion para mostrar la pregunta que ha realizado el usuario en el apartado del perfil:
function verHistorial(e){
  if(indexedDB){ //Si existe la base de datos entonces..
    //Nos devuelve un bjeto de tipo transaccion
    const transaction = db.transaction('historial','readwrite');
    //Dentro de este objeto tenemos el método objectStore y este método recibe el almacen
    const objectStore = transaction.objectStore('historial');
    //Recibir todos los datos
    const request = objectStore.getAll();
    console.log(indexedDB);
    request.onsuccess = (e) => {
        let preguntas = e.target.result;//El resultado del request
          for (let pregunta of preguntas) {
            cargarLayoutPregunta(pregunta);
          }
    };
    document.getElementById('his').disabled=true; //De esta forma no se repite la misma pregunta cada vez que pulsamos el boton ver-historial
  }

}



