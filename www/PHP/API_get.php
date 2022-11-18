<?php
    session_start();
    require ('../db_functions.php');

    $dbh = connect();


    //Funciones
    function api_getPreguntas(){
        global $dbh;

        $preguntas = getVistaPreguntas($dbh);
        foreach ($preguntas as &$pregunta) { //pasamos por referencia para modificar cada elemento del array
            // obtengo el id de cada pregunta
            $id_preg = $pregunta['id_preg'];

            // obtengo los likes por cada pregunta
            $likes = countLikes($dbh, $id_preg)->like;

            // a cada pregunta, meterle su cantidad de likes
            // hay que poder modificar la pregunta para que esta linea tenga sentido
            $pregunta['likes'] = $likes;

            // obtengo las respuestas por cada pregunta
            $respuestas = countRespuestas($dbh, $id_preg)->respuestas;
            $pregunta['respuestas'] = $respuestas;
        }

        return $preguntas;
    }

    //Funciones
    function api_getPregunta(){
        global $dbh;

        $preguntas = getVistaPregunta($dbh);
        foreach ($preguntas as &$pregunta) { 
            $id_preg = $pregunta['id_preg'];

            // obtengo los likes por cada pregunta
            $likes = countLikes($dbh, $id_preg)->like;
            $pregunta['likes'] = $likes;
        }


        return $preguntas;
    }

    function api_getRespuestas(){
        global $dbh;

        $preguntas = getVistaRespuestas($dbh);
        foreach ($preguntas as &$pregunta) { 
            $id_preg = $pregunta['id_preg'];

            // obtengo los votos de cada pregunta
            $votos = countVotos($dbh, $id_preg)->voto;
            $pregunta['votos'] = $votos;
        }

        return $preguntas;
    }


    //Vamos a comprobar que lo que 
    $funcion = isset($_GET['funcion']) ? $_GET['funcion'] : null;

    //Cada respuesta que nos va a dar la API
    $respuesta = [];

    switch ($funcion) {
        case 'getPreguntas':
            $respuesta = api_getPreguntas();
            break;
        case 'getDetallesPregunta':
            $respuesta = api_getPregunta();
            break;
        case 'getRespuestas':
            $respuesta = api_getRespuestas();
            break;
        default:
            break;
    }

    header('Content-Type', 'application/json');
    echo json_encode($respuesta);
?>