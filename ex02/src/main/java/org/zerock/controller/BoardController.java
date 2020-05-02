package org.zerock.controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import org.zerock.domain.BoardVO;
import org.zerock.domain.Criteria;
import org.zerock.domain.PageDTO;
import org.zerock.service.BoardService;

import lombok.AllArgsConstructor;
import lombok.extern.log4j.Log4j;

@Controller
@Log4j
@RequestMapping("/board/*")
@AllArgsConstructor
public class BoardController {

	private BoardService service;

	/*
	 * @GetMapping("/list") public void list(Model model) { log.info("list");
	 * //list()는 나중에 게시물의 목록을 전달해야하므로 Model을 파마미터로 정하고, 이를 통해서 boardServiceImpl 객체의
	 * //getList()결과를 담아 전달합니다(addAttribute) model.addAttribute("list",
	 * service.getList()); }
	 */

	@GetMapping("/list")
	public void list(Criteria cri, Model model) {
		log.info("list:" + cri);
		model.addAttribute("list", service.getList(cri));
		
		// boardController에서 pageDTO를 사용할 수 있도록 Model에 담아서 화면에 전달, 임의의값 123 넣음
		//model.addAttribute("pageMaker", new PageDTO(cri, 123));
		
		int total = service.getTotal(cri);
		
		log.info("total: "+ total);
		model.addAttribute("pageMaker", new PageDTO(cri, total))
;	}

	@PostMapping("/register")
	public String register(BoardVO board, RedirectAttributes rttr) {
		log.info("register: " + board);
		service.register(board);
		rttr.addFlashAttribute("result", board.getBno());
		// redirect: 접두어를 사용하면 스프링 MVC가 내부적으로 response.sendRedirect()를 처리
		// return "return:/board/list";
		return "redirect:/board/list";
	}

	// getMapping이나 postMapping에서는 url을 배열로 처리할 수 있다.
	// @ModelAttribute는 자동으로 Model에 데이터를 지정한 이름으로 담아줍니다. 사용하지 않아도 전달이 되지만 명확히 하게 위해서
	// 사용
	@GetMapping({ "/get", "/modify" })
	public void get(@RequestParam("bno") Long bno, @ModelAttribute("cri") Criteria cri, Model model) {
		log.info("/get or /modify");
		model.addAttribute("board", service.get(bno));
	}

	@PostMapping("/modify")
	public String modify(BoardVO board, @ModelAttribute("cri") Criteria cri, RedirectAttributes rttr) {
		log.info("modify: " + board);

		if (service.modify(board)) {
			rttr.addFlashAttribute("result", "success");
		}

		rttr.addAttribute("pageNum", cri.getPageNum());
		rttr.addAttribute("amount", cri.getAmount());

		return "redirect:/board/list";
	}

	@PostMapping("/remove")
	public String remove(@RequestParam("bno") Long bno, @ModelAttribute("cri") Criteria cri, RedirectAttributes rttr) {
		log.info("remove.................... " + bno);

		if (service.remove(bno)) {
			rttr.addFlashAttribute("result", "success");
		}
		
		rttr.addAttribute("pageNum", cri.getPageNum());
		rttr.addAttribute("amount", cri.getAmount());
		
		return "redirect:/board/list";
	}

	@GetMapping("/register")
	public void register() {

	}
}
