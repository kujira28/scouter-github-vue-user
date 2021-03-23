<?php
function dirToArray($dir, $url) {
    $result = array(); 
    $cdir = scandir($dir);
    $i = 0;
    foreach ($cdir as $key => $value) {
        if (!in_array($value, array(".", ".."))) {
            if (is_dir($dir . DIRECTORY_SEPARATOR . $value)) {
                $url .= DIRECTORY_SEPARATOR . $value;
                $result[$i]['name'] = $value;
                $result[$i]['children'] = dirToArray($dir . DIRECTORY_SEPARATOR . $value, $url);
            } else {
                $result[$i]['name'] = $value;
                $result[$i]['path'] = $dir . DIRECTORY_SEPARATOR . $value;
		$file = pathinfo($value);
		if(isset($file['extension'])) {
                    $result[$i]['file'] = $file['extension'];
		}
            }
	    $i++;
	}
    }

    return $result;
}

$dir = '/var/www/scouter-github-vue';
$url = '.';
$array = dirToArray($dir, $url);
echo serialize($array);
