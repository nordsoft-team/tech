<?php
    // php.ini display_errors = On
    $con = mysqli_connect("localhost","root","123456","mysql");
    $sql = "SELECT now() FROM dual";
    $result = $con->query($sql);
    $row = $result->fetch_assoc();
    echo $row["now()"];
    $con->close();
    phpinfo();
?>