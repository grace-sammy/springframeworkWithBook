<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ include file="../includes/header.jsp"%>


<script type="text/javascript">

$(document).ready(function() {

	var result = '<c:out value="${result}"/>';
	checkModal(result);
	history.replaceState({}, null, null);

	
	function checkModal(result) {
		if (result === '' || history.state) {
			return;
		}
		if (parseInt(result) > 0) {
			$(".modal-body").html(
					"게시글 " + parseInt(result)
							+ " 번이 등록되었습니다.");
		}
		$("#myModal").modal("show");
	}

	$("#regBtn").on("click", function() {
		self.location = "/board/register";
	});

	
	var actionForm = $("#actionForm");
	$(".paginate_button a").on("click",	function(e) {
			//<a> 태그를 클릭해도 페이지 이동이 없도록 처리
			e.preventDefault();
			console.log('click');

			//<form> 태그 내 pageNum 값은 href 속성값으로 변경 -> 
			//이 처리를 하면 화면에서 페이지 번호를 클릭했을 때 <form>태그 내의 페이지 번호가 바뀌는 것을 확인할 수 있다.
			actionForm.find("input[name='pageNum']").val($(this).attr("href"));
			actionForm.submit();
			});
	
	//list.jsp 게시물 조회를 위한 이벤트 처리 추가 
	$(".move").on("click", function(e) {
		
			e.preventDefault();
			//게시물의 제목을 클릭하면 form 태그 에 추가로 bno값을 전송하기 위해 input태그를 만들어 추가하고
			//form태그의 action은 /board/get으로 변경한다.
			actionForm.append("<input type='hidden' name='bno' value='"	+ $(this).attr("href")+ "'>");
			
			//attr()을 통해서는 element가 가지는 속성값이나 정보를 조회하거나 세팅
			actionForm.attr("action", "/board/get");
			
			actionForm.submit();
			});

	
	var searchForm = $("#searchForm");

	$("#searchForm button").on("click",	function(e) {

				if (!searchForm.find("option:selected").val()) 
				{
					alert("검색종류를 선택하세요");
					return false;
				}

				if (!searchForm.find("input[name='keyword']").val()) 
				{
					alert("키워드를 입력하세요");
					return false;
				}

				searchForm.find("input[name='pageNum']").val("1");

				e.preventDefault();
				
				searchForm.submit();
				
				});
});
</script>

<div class="row">
	<div class="col-lg-12">
		<h1 class="page-header">Tables</h1>
	</div>
	<!-- /.col-lg-12 -->
</div>
<!-- /.row -->
<div class="row">
	<div class="col-lg-12">
		<div class="panel panel-default">
			<div class="panel-heading">DataTables Advanced Tables</div>
			<!-- /.panel-heading -->
			<div class="panel-body">
				<table class="table table-striped table-bordered table-hover">
					<thead>
						<tr>
							<th>#번호</th>
							<th>제목</th>
							<th>작성자</th>
							<th>작성일</th>
							<th>수정일</th>
						</tr>
					</thead>

					<c:forEach items="${list}" var="board">
						<tr>
							<td>
								<c:out value="${board.bno}" />
							</td>
							<td>
								<!-- 만약 새창을 통해 보고싶다면 target='_blank' 를 추가하면 된다-->
								<%-- a 태그로 링크를 생성하여 이동하는 방법
								<a href='/board/get?bno=<c:out value="${board.bno}"/>'> --%>
								
								<!-- 이벤트 처리를 수월하게 하기 위해서 <a>태그에 class속성을 부여  -->
								<a class='move' href='<c:out value="${board.bno}"/>'>
								<c:out value="${board.title}" />
								</a>
							</td>

							<td>
								<c:out value="${board.writer}" />
							</td>
							<td>
								<fmt:formatDate pattern="yyyy-MM-dd" value="${board.regdate}" />
							</td>
							<td>
								<fmt:formatDate pattern="yyyy-MM-dd" value="${board.updateDate}" />
							</td>
						</tr>
					</c:forEach>
				</table>
				<!-- /.table-responsive -->

				<!-- 페이징처리 -->
				<div class='pull-right'>
					<ul class="pagination">
						<c:if test="${pageMaker.prev}">
							<li class="paginate_button previous"><a href="${pageMaker.startPage -1}">previous</a></li>
						</c:if>

						<c:forEach var="num" begin="${pageMaker.startPage}" end="${pageMaker.endPage}">
							<li class="paginate_button  ${pageMaker.cri.pageNum == num ? "active":""} "><a href="${num}">${num}</a></li>
						</c:forEach>

						<c:if test="${pageMaker.next}">
							<li class="paginate_button next"><a href="${pageMaker.endPage +1}">Next</a></li>
						</c:if>
					</ul>
				</div>
				<!-- end of pull-right, end pagination -->
			</div>

			<form id='actionForm' action="/board/list" method='get'>
				<input type='hidden' name='pageNum' value='${pageMaker.cri.pageNum}'>
				<input type='hidden' name='amount' value='${pageMaker.cri.amount}'>
				<input type='hidden' name='type' value='<c:out value="${ pageMaker.cri.type }"/>'>
				<input type='hidden' name='keyword' value='<c:out value="${ pageMaker.cri.keyword }"/>'>
			</form>

		</div>
		<!-- /.panel-body -->
	</div>
	<!-- /.panel -->
</div>
<!-- /.col-lg-12 -->
</div>
<!-- /.row -->


<%@include file="../includes/footer.jsp"%>
