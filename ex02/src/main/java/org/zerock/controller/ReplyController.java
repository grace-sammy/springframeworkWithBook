package org.zerock.controller;

import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;
import org.zerock.domain.Criteria;
import org.zerock.domain.ReplyPageDTO;
import org.zerock.domain.ReplyVO;
import org.zerock.service.ReplyService;

import lombok.AllArgsConstructor;
import lombok.extern.log4j.Log4j;

//REST방식을 처리할 때 주의해야할 점은 브라우저나 외부에서 서버를 호출할 때 데이터의 포맷과 서버에서 보내주는 데이터의 타입을 명확히 설계해야한다는 것이다.
//예를 들어 댓글 등록의 경우 브라우저에서는 JSON타입으로 된 댓글 데이터를 전송하고, 서버에서는 댓글의 처리 결과가 정상적으로 되었는지 문자열로 결과를 알려주도록 합니다.
@RequestMapping("/replies/")
@RestController
@Log4j
@AllArgsConstructor
public class ReplyController {
	private ReplyService service;

	@PostMapping(value = "/new", consumes = "application/json", produces = { MediaType.TEXT_PLAIN_VALUE })
	public ResponseEntity<String> create(@RequestBody ReplyVO vo) {
// create의 parameter는 @RequestBody를 적용해서 JSON 데이터를 ReplyVO타입으로 변환하도록 지정
		log.info("ReplyVO: " + vo);

		int insertCount = service.register(vo);

		log.info("Reply INSERT COUNT: " + insertCount);

		return insertCount == 1 ? new ResponseEntity<>("success", HttpStatus.OK)
				: new ResponseEntity<>(HttpStatus.INTERNAL_SERVER_ERROR);
	}

// 댓글의 수정/삭제/조회는 JSON이나 문자열을 반환하도록 설계함
	@GetMapping(value = "/{rno}", produces = { MediaType.APPLICATION_XML_VALUE, MediaType.APPLICATION_JSON_UTF8_VALUE })
	public ResponseEntity<ReplyVO> get(@PathVariable("rno") Long rno) {

		log.info("get: " + rno);

		return new ResponseEntity<>(service.get(rno), HttpStatus.OK);
	}

// 댓글 수정,json 형태로 전달되는 데이터와 파라미터로 전달되는 댓글 번호(rno)를 처리하도록
	// 댓글 수정은 PUT 방식이나 Patch 방식을 이용하도록 처리하고, 실제 수정되는 데이터는 JSON 포맷이므로 @RequestBody를
	// 이용해서 처리합니다.
	// @RequestBody로 처리되는 데이터는 일반 파라미터나 @PathVariable 파라미터를 처리할 수 없기 때문에 직접 처리해 주는
	// 부분을 주의해야한다.
	@RequestMapping(method = { RequestMethod.PUT,
			RequestMethod.PATCH }, value = "/{rno}", consumes = "application/json", produces = {
					MediaType.TEXT_PLAIN_VALUE })
	public ResponseEntity<String> modify(@RequestBody ReplyVO vo, @PathVariable("rno") Long rno) {

		vo.setRno(rno);

		log.info("rno: " + rno);
		log.info("modify: " + vo);

		return service.modify(vo) == 1 ? new ResponseEntity<>("success", HttpStatus.OK)
				: new ResponseEntity<>(HttpStatus.INTERNAL_SERVER_ERROR);

	}

	@DeleteMapping(value = "/{rno}", produces = { MediaType.TEXT_PLAIN_VALUE })
	public ResponseEntity<String> remove(@PathVariable("rno") Long rno) {

		log.info("remove: " + rno);

		return service.remove(rno) == 1 ? new ResponseEntity<>("success", HttpStatus.OK)
				: new ResponseEntity<>(HttpStatus.INTERNAL_SERVER_ERROR);

	}

//	 @GetMapping(value = "/pages/{bno}/{page}", 
//			 produces = {
//					 MediaType.APPLICATION_XML_VALUE,
//					 MediaType.APPLICATION_JSON_UTF8_VALUE })
//	 public ResponseEntity<List<ReplyVO>> getList(
//			 @PathVariable("page") int page,
//			 @PathVariable("bno") Long bno) {
//	
//		 
//		 log.info("getList.................");
//		 Criteria cri = new Criteria(page,10);
//		 log.info(cri);
//	
//	 return new ResponseEntity<>(service.getList(cri, bno), HttpStatus.OK);
//	 }

	@GetMapping(value = "/pages/{bno}/{page}", produces = { MediaType.APPLICATION_XML_VALUE,
			MediaType.APPLICATION_JSON_UTF8_VALUE })
	public ResponseEntity<ReplyPageDTO> getList(@PathVariable("page") int page, @PathVariable("bno") Long bno) {

		Criteria cri = new Criteria(page, 10);

		log.info("get Reply List bno: " + bno);

		log.info("cri:" + cri);

		return new ResponseEntity<>(service.getListPage(cri, bno), HttpStatus.OK);
	}

}
