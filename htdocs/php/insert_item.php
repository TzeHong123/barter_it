<?php
if (!isset($_POST)) {
    $response = array('status' => 'failed', 'data' => null);
    sendJsonResponse($response);
    die();
}

include_once("dbconnect.php");

$userid = $_POST['userid'];
$item_name = $_POST['itemname'];
$item_desc = $_POST['itemdesc'];
//$item_price = $_POST['itemprice'];
$item_type = $_POST['type'];
$item_qty = $_POST['itemqty'];
$item_lat = $_POST['latitude'];
$item_long = $_POST['longitude'];
$item_state = $_POST['state'];
$item_locality = $_POST['locality'];
$image1 = $_POST['image1'];
$image2 = $_POST['image2'];
$image3 = $_POST['image3'];

$sqlinsert = "INSERT INTO `tbl_items`(`user_id`, `item_name`, `item_desc`, `item_type`, `item_qty`, `item_lat`, `item_long`, `item_state`, `item_locality`) VALUES ('$userid', '$item_name','$item_desc','$item_type','$item_qty', '$item_lat','$item_long','$item_state','$item_locality')";

if ($conn->query($sqlinsert) === TRUE) {
	$filename = mysqli_insert_id($conn);
	$response = array('status' => 'success', 'data' => null);

	//$decoded_string = base64_decode($image);
	//$path = '../assets/items/'.$filename.'.png';
	//file_put_contents($path, $decoded_string);

	if (!empty($image1)) {
        $decoded_string = base64_decode($image1);
        $path = '../assets/items/' . $filename . '_Image1.png';
        file_put_contents($path, $decoded_string);
    }

    	if (!empty($image2)) {
        $decoded_string = base64_decode($image2);
        $path = '../assets/items/' . $filename . '_Image2.png';
        file_put_contents($path, $decoded_string);
    }

    	if (!empty($image3)) {
        $decoded_string = base64_decode($image3);
        $path = '../assets/items/' . $filename . '_Image3.png';
        file_put_contents($path, $decoded_string);
    }

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