<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ include file="../includes/header.jsp"%>

<div class="row">
	<div class="col-lg-12">
		<h1 class="page-header">Board Read</h1>
	</div>
	<!--  /.col-lg-12 -->
</div>
<!-- /.row -->
<div class="row">
	<div class="col-lg-12">
		<div class="panel panel-default">
			<div class="panel-heading">Board Read Page</div>
			<!-- /.panel-heading -->

			<div class="panel-body">

				<div class="form-group">
					<label>Bno</label>
					<input class="form-control" name='bno' readOnly="readonly" value='<c:out value="${board.bno}"/>'>
				</div>

				<div class="form-group">
					<label>Title</label>
					<input class="form-control" name='title' readOnly="readonly" value='<c:out value="${board.title}"/>'>
				</div>

				<div class="form-group">
					<label>Text area</label>
					<textarea class="form-control" rows="3" name='content' readOnly="readonly"><c:out value="${board.content}" /></textarea>
				</div>

				<div class="form-group">
					<label>Writer</label>
					<input class="form-control" name='writer' readOnly="readonly">
				</div>

				<%--1.  직접 링크를 걸어서 처리하는 방법 , 이것 두줄 사용
				<button data-oper='modify' class="btn btn-default" onclick="location.href='/board/modify?bno=<c:out value="${board.bno }"/>'">Modify</button>
				<button data-oper='list' class="btn btn-default" onclick="location.href='/board/list'">List</button> --%>

				<!--2. 직접 링크를 걸지 않는 방법 -->
				<button data-oper='modify' class="btn btn-default">Modify</button>
				<button data-oper='list' class="btn btn-info">List</button>


				<!-- 브라우저에서는 form 태그의 내용은 보이지 않고 버튼만이 보이게 된다. 사용자가 버튼을 클릭하면 openForm이라는 id를 가진 <form>태그를 전송해야
				하므로 추가적인 JavaScript 처리가 필요 -->
				
				<form id='operForm' action="/board/modify" method="get">
					<input type='hidden' id='bno' name='bno' value='<c:out value="${board.bno}"/>'>
					<!--pageNum, amount 값을 같이 전달해줄 경우, 글을 읽은 후 리스트로 돌아갈때 보던 리스트로 돌아갈 수 있다. -->
					<!--  http://localhost:8080/board/list?pageNum=5&amount=10  이렇게 전달이 된다.-->
					<input type='hidden' name='pageNum' value='<c:out value="${cri.pageNum}"/>'>
					<input type='hidden' name='amount' value='<c:out value="${cri.amount}"/>'>
					<input type='hidden' name='keyword' value='<c:out value="${cri.keyword}"/>'>
					<input type='hidden' name='type' value='<c:out value="${cri.type}"/>'>
				</form>
			</div>
			<!-- end panel-body -->
		</div>
		<!-- end panel -->
	</div>
	<!-- /.row -->
</div>



<script type="text/javascript">
	$(document).ready(function() {

		var operForm = $("#operForm");

		//사용자가 수정버튼을 누르는 순간
		//$("태그[속성명=속성값]") == $(":input태그의 type명") ex) $(":checkbox")
		$("button[data-oper='modify']").on("click", function(e) {

			operForm.attr("action", "/board/modify").submit();

		});

		//사용자가 list로 이동하는 경우 아직 아무런 데이터도 필요하지 않으므로 form태그 내의 bno태그를 지우고 submit을 통해서 리스트 페이지로 이동
		$("button[data-oper='list']").on("click", function(e) {

			operForm.find("#bno").remove();

			operForm.attr("action", "/board/list")

			operForm.submit();

		});
	});
</script>
<%@include file="../includes/footer.jsp"%>