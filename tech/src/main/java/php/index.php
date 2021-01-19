<?php
    $con = mysqli_connect("localhost","root","123456","mysql");
    $sql = "SELECT now() FROM dual";
    $result = $con->query($sql);
    $row = $result->fetch_assoc();
    echo $row["now()"];
    $con->close();

    phpinfo();
?>

// 1.use brew to install php7
// 2.use PhpStorm to start php page

// display_errors = On
// /opt/homebrew/etc/php/7.4/php.ini