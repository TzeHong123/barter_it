<?php
if (!isset($_POST)) {
    $response = array('status' => 'failed', 'data' => null);
    sendJsonResponse($response);
    die();
}

include_once("dbconnect.php");

$recordid = $_POST['recordid'];
$status = $_POST['status'];
$owner_phone = $_POST['owner_phone'];
//$lat = $_POST['lat'];
//$lng = $_POST['lng'];

$sqlupdate = "UPDATE `tbl_records` SET `record_status`='$status' WHERE record_id = '$recordid'";

$sqlupdateownerphone = "UPDATE `tbl_records` SET `owner_phone`='$owner_phone' WHERE record_id = '$recordid'";
$conn->query($sqlupdateownerphone);

if ($conn->query($sqlupdate) === TRUE) {
	$response = array('status' => 'success', 'data' => null);
    sendJsonResponse($response);
}else{
	$response = array('status' => 'failed', 'data' => null);
	sendJsonResponse($response);
}

function sendJsonResponse($sentArray)
{
    header('Content-Type: application/json');
    echo json_encode($sentArray);
}

?>