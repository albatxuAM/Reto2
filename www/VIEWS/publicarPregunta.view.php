
    <div class="datos recuadroFormu">
        <form action="post">
            <div class="izq">
                <h2>PREGUNTAR A OTROS USUARIOS</h2><br>
                <label for="usuario">Usuario</label>
                <input class="inputs" type="text" name="usuario" id="usuario">
                <br><br>
                <label for="titulo">Titulo</label>
                <input class="inputs" type="text" name="titulo" id="titulo">
                <br><br>
                <label for="categoria">Categoria</label>
                <select class="inputs" name="categoria" id="categoria">
                    <option value="C01">Categoria 1</option>
                    <option value="C02">Categoria 2</option>
                    <option value="C03">Categoria 4</option>
                    <option value="C04">Categoria 4</option>
                </select>
                <br><br>
                <label for="detalle">Detalle</label>
                <textarea class="inputs" name="detalle" id="detalle" cols="30" rows="10"></textarea>
            </div> 
            <div class="der end">
                <label for="archivo">Subir archivo</label>
                <input class="inputs" type="file" name="archivo" id="archivo">
            </div> 
            <input type="submit" value="Enviar">
        </form>
    </div>