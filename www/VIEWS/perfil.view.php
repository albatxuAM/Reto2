<?php require('VIEWS/PARTIALS/header.php') ?>

<div id="perfil">
    <div class="recuadro">
        <form method="post" action="#" enctype="multipart/form-data" class="formulario">
            <div class="izq">
                <h2>DETALLES</h2><br>

                <label for="nombre">Nombre: </label>
                <input class="inputs" type="text" name="pnombre" id="nombre" value="<?php echo $_COOKIE['Nombre'] ?>" disabled required="">
                <b style="color:red" id="nombreIncorrecto" hidden>Nombre invalido</b><br><br>

                <label for="apellidos">Apellidos: </label>
                <input class="inputs" type="text" name="papellidos" id="apellidos" value="<?php echo $_COOKIE['Apellido'] ?>" disabled required="">
                <b style="color:red" id="apellidosIncorrectos" hidden>Apellidos invalidos</b><br><br>
      
                <label for="contraseniaBtn">Contraseña:</label>
                <input type="button" class="inputs" name="contraseña" id="contraseniaBtn" value="Cambiar contraseña" disabled><br>
                <div id="cambiarPASS">
                    <h3>Confirmación nueva contraseña</h3>
                    <br>
                    <label>Cambiar contraseña</label><br>
                    <input  class="inputs" type = "password" id = "contra1">
                    <br><br>
                    <label>Confirmar contraseña </label><br>
                    <input  class="inputs" type = "password" id = "contra2" name="cambiarpass">
                    <br><br>
                    <p style="color:red" id="passIncorrecta" hidden>Las contraseñas no coinciden</p>
                    <input type="reset" value="Vaciar"><br>
                </div>
                <br>
                <label for="email">Email: </label>
                <input class="inputs" type="email" name="pemail" id="email" value="<?php echo $_COOKIE['Email'] ?>" disabled required="">
                <b style="color:red" id="emailIncorrecto" hidden>Email invalido</b><br><br>
                <input class="inputs" type="submit" value="GUARDAR CAMBIOS" id="guardarPerfil" disabled>
            </div>
            <div class="der end">
                <output id="list"></output>
                <img src="../RECURSOS/IMAGES/user.png" alt="Foto de perfil" class="perfil" id="fotoperfil" hidden><br><br>
                <input class="inputs" type="file" name="pfoto" id="foto" disabled><br><br>
                <input type="button" value="EDITAR PERFIL" id="editar">
                <input type="button" value="HISTORIAL PREGUNTAS" id="his">
            </div>
        </form>
        
    </div> 
    <div class='historial-preguntas'></div>

    <script src="../JS/cookiesPerfil.js"></script>    
    <script src="../JS/perfil.js"></script>
    <noscript>El navegador no soporta JavaScript</noscript>
</div>
<script src="../JS/perfil.js"></script>

<?php require('VIEWS/PARTIALS/footer.php') ?>
