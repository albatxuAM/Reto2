let buscar = document.getElementById("buscar");
let categoria = document.getElementById("categoria");
let orden = document.getElementById("order");

const queryString = window.location.search;
const urlParams = new URLSearchParams(queryString);

function cargarBusqueda() {
    if(urlParams.has('buscar')) {   
        buscar.value = urlParams.get('buscar');
    }

    if(urlParams.has('categoria')) {    
        document.getElementById("categoria").value = urlParams.get('categoria');
    }

    if(urlParams.has('order')) {
        orden.value = urlParams.get('order');
    }

}

cargarBusqueda();