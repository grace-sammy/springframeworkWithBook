<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
</head>
<body>
	<h1>Upload with Ajax</h1>

	<style>
.uploadResult {
	width: 100%;
	background-color: gray;
}

.uploadResult ul {
	display: flex;
	flex-flow: row;
	justify-content: center;
	align-items: center;
}

.uploadResult ul li {
	list-style: none;
	padding: 10px;
}

.uploadResult ul li img {
	width: 100px;
}
</style>

	<style>
.bigPictureWrapper {
	position: absolute;
	display: none;
	justify-content: center;
	align-items: center;
	top: 0%;
	width: 100%;
	height: 100%;
	background-color: gray;
	z-index: 100;
}

.bigPicture {
	position: relative;
	display: flex;
	justify-content: center;
	align-items: center;
}
</style>

	<div class='bigPictureWrapper'>
		<div class='bigPicture'></div>
	</div>

<!-- input 타입이 파일인 경우 다른 DOM 요소들과 다르게 readOnly라 별도의 방법으로 초기화 시켜서 또 다른 첨부파일을 추가할 수 있도록 만들어야함,
첨부파일을 업로드할 때마다 목록에 추가되고, input type='file'부분은 초기화 -->
	<div class='uploadDiv'>
		<input type='file' name='uploadFile' multiple>
	</div>

	<div class='uploadResult'>
		<ul>

		</ul>
	</div>

	<button id='uploadBtn'>Upload</button>

	<script src="https://code.jquery.com/jquery-3.3.1.min.js" integrity="sha256-FgpCb/KJQlLNfOu91ta32o/NMZxltwRo8QtmkMRdAu8=" crossorigin="anonymous"></script>

	<script>

	function showImage(fileCallPath){
	  
	  $(".bigPictureWrapper").css("display","flex").show();
	  
	  $(".bigPicture")
	  .html("<img src='/display?fileName="+fileCallPath+"'>")
	  .animate({width:'100%', height: '100%'}, 1000);

	}
	
	$(".bigPictureWrapper").on("click", function(e){
	  $(".bigPicture").animate({width:'0%', height: '0%'}, 1000);
	  setTimeout(() => {
	    $(this).hide();
	  }, 1000);
	});

	
	$(".uploadResult").on("click","span", function(e){
	   
	  var targetFile = $(this).data("file");
	  var type = $(this).data("type");
	  console.log(targetFile);
	  
	  $.ajax({
	    url: '/deleteFile',
	    data: {fileName: targetFile, type:type},
	    dataType:'text',
	    type: 'POST',
	      success: function(result){
	         alert(result);
	       }
	  }); //$.ajax
	  
	});

		var regex = new RegExp("(.*?)\.(exe|sh|zip|alz)$");
		var maxSize = 5242880; //5MB

		//파일의 확장자나 크기의 사전 처리
		function checkExtension(fileName, fileSize) {

			if (fileSize >= maxSize) {
				alert("파일 사이즈 초과");
				return false;
			}

			if (regex.test(fileName)) {
				alert("해당 종류의 파일은 업로드할 수 없습니다.");
				return false;
			}
			return true;
		}

		var cloneObj = $(".uploadDiv").clone();

		$("#uploadBtn").on("click", function(e) {

			var formData = new FormData();

			var formData = new FormData();

			var inputFile = $("input[name='uploadFile']");

			var files = inputFile[0].files;

			//console.log(files);

			for (var i = 0; i < files.length; i++) {

				if (!checkExtension(files[i].name, files[i].size)) {
					return false;
				}

				formData.append("uploadFile", files[i]);

			}


			$.ajax({
				url : '/uploadAjaxAction',
				processData : false,
				contentType : false,
				data : formData,
				type : 'POST',
				dataType : 'json',
				success : function(result) {

					console.log(result);

					showUploadedFile(result);

					$(".uploadDiv").html(cloneObj.html());

				}
			}); //$.ajax

		});

		var uploadResult = $(".uploadResult ul");


		//json 데이터를 받아서 해당 파일의 이름을 추가
		//브라우저에서 GET방식으로 첨부파일의 이름을 사용할 때에는 항상 파일의 이름에 포함된 공백 문자나 한글 이름 등이 문제가 될 수 있다.
		//이를 수정하기 위해 encodeURIComponent()를 이용해서 URI호출에 적합한 문자열로 인코딩 처리해야한다.
 function showUploadedFile(uploadResultArr){
 
   var str = "";
   
   $(uploadResultArr).each(function(i, obj){
     
         //이미지 종류가 아닌 파일의 경우, 파일 아이콘이 보이드록 함
     if(!obj.image){
        //encodeURIComponent() 함수는 URI의 특정한 문자를 UTF-8로 인코딩해 하나, 둘, 셋, 혹은 네 개의 연속된 이스케이프 문자로 나타냅니다.
        //(두 개의 대리 문자로 이루어진 문자만 이스케이프 문자 네 개로 변환됩니다.), 크롬과 IE의 경우 서로 다르게 처리되어 첨부파일에 문제가 있을 수도 있다
        //1. encodeURI() : decodeURI()
		// :escape()와 같이 변환을 하지만, 인터넷 주소에서 쓰는 특수 문자  : ; / = ? &  는 변환을 하지 않습니다.
		//2. encodeURIComponent() : decodeURIComponent()
		// :인터넷 주소에서 쓰는 특수 문자  : ; / = ? &  까지 변환을 합니다. 인터넷 주소를 하나의 변수에 넣을때 쓸 수 있습니다. 
		//URL을 통째로 인코딩할 때는 encodeURI(), URL의 파라메터만 인코딩할 때는 encodeURIComponent()를 쓰면 된다.
       var fileCallPath =  encodeURIComponent( obj.uploadPath+"/"+ obj.uuid +"_"+obj.fileName);
       var fileLink = fileCallPath.replace(new RegExp(/\\/g),"/");
       str += "<li><div><a href='/download?fileName="+fileCallPath+"'>"+
           "<img src='/resources/img/attach.png'>"+obj.fileName+"</a>"+
           "<span data-file=\'"+fileCallPath+"\' data-type='file'> x </span>"+
           "<div></li>"
           
     }else{
       var fileCallPath =  encodeURIComponent( obj.uploadPath+ "/s_"+obj.uuid +"_"+obj.fileName);
       var originPath = obj.uploadPath+ "\\"+obj.uuid +"_"+obj.fileName;
       originPath = originPath.replace(new RegExp(/\\/g),"/");
       
       str += "<li><a href=\"javascript:showImage(\'"+originPath+"\')\">"+
              "<img src='display?fileName="+fileCallPath+"'></a>"+
              "<span data-file=\'"+fileCallPath+"\' data-type='image'> x </span>"+
              "<li>";
     }
   });
   
   uploadResult.append(str);
 }

	</script>


</body>
</html>
