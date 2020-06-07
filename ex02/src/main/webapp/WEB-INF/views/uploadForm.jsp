<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>

<!-- multipart/form-data => 여러개의 파일을 업로드 가능하게 함 -->
	<form action="uploadFormAction" method="post" enctype="multipart/form-data">
		<input type='file' name='uploadFile' multiple>
		<button>Submit</button>
	</form>

</body>
</html>