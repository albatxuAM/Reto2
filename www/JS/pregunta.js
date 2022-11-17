/**
 * @author    GRUPO 1 <wat2022.wordpress.com>
 **/

'use strict'

async function actualizarVisto(id_preg) {
    console.log('JS pregunta = ', id_preg);
    debugger;
    fetch('../PHP/pregunta.php', {
            method: 'POST',
            async: true,
            headers: { 'Content-Type': 'application/json;charset=utf-8' },
            body: JSON.stringify({"id_preg": id_preg})
        })
    .then(function(response) {
        return response.json ();
    })
    .then(function(data) {
        console.log('data = ', data);
    })
    .catch(function(err) {
        console.error(err);
    });
}