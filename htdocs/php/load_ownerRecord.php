<?php
if (!isset($_POST)) {
    $response = array('status' => 'failed', 'data' => null);
    sendJsonResponse($response);
    die();
}

include_once("dbconnect.php");

if (isset($_POST['ownerid'])){
	$ownerid = $_POST['ownerid'];	
	$sqlrecord = "SELECT * FROM `tbl_records` WHERE owner_id = '$ownerid'";
}
//`record_id`, `record_bill`, `record_paid`, `owner_id`, `trader_id`, `record_date`, `record_status`

$result = $conn->query($sqlrecord);
if ($result->num_rows > 0) {
    $oderitems["records"] = array();
	while ($row = $result->fetch_assoc()) {
        $recordlist = array();
        $recordlist['record_id'] = $row['record_id'];
        //$recordlist['record_bill'] = $row['record_bill'];
        $recordlist['trader_id'] = $row['trader_id'];
        $recordlist['owner_id'] = $row['owner_id'];
        $recordlist['record_date'] = $row['record_date'];
        $recordlist['record_status'] = $row['record_status'];
        //$recordlist['record_lat'] = $row['record_lat'];
        //$recordlist['record_lng'] = $row['record_lng'];
        array_push($oderitems["records"] ,$recordlist);
    }
    $response = array('status' => 'success', 'data' => $oderitems);
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