<?php
    $con = mysqli_connect("localhost","root","Abcd1234","nordsoft");
    $sql = "SELECT now() FROM dual";
    $result = $con->query($sql);
    $row = $result->fetch_assoc();
    echo $row["now()"];
    $con->close();
?>