package org.zerock.controller;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.net.URLDecoder;
import java.net.URLEncoder;
import java.nio.file.Files;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.UUID;

import org.springframework.core.io.FileSystemResource;
import org.springframework.core.io.Resource;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.util.FileCopyUtils;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestHeader;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.zerock.domain.AttachFileDTO;

import lombok.extern.log4j.Log4j;
import net.coobird.thumbnailator.Thumbnailator;

@Controller
@Log4j
public class UploadController {

	@GetMapping("/uploadForm")
	public void uploadForm() {

		log.info("upload form");
	}
	
	//브라우저로 전송해야야 하는 데이터: 업로드된 파일의 이름과 원본 파일의 이름, 파일이 저장된 경로, 업로드된 파일이 이미지인지 아닌지에 대한 정보

	// @PostMapping("/uploadFormAction")
	// public void uploadFormPost(MultipartFile[] uploadFile, Model model) {
	//
	// for (MultipartFile multipartFile : uploadFile) {
	//
	// log.info("-------------------------------------");
	// log.info("Upload File Name: " +multipartFile.getOriginalFilename());
	// log.info("Upload File Size: " +multipartFile.getSize());
	//
	// }
	// }

	@PostMapping("/uploadFormAction")
	public void uploadFormPost(MultipartFile[] uploadFile, Model model) {

		String uploadFolder = "C:\\upload";

		for (MultipartFile multipartFile : uploadFile) {

			log.info("-------------------------------------");
			log.info("Upload File Name: " + multipartFile.getOriginalFilename());
			log.info("Upload File Size: " + multipartFile.getSize());

			File saveFile = new File(uploadFolder, multipartFile.getOriginalFilename());

			try {
				multipartFile.transferTo(saveFile);
			} catch (Exception e) {
				log.error(e.getMessage());
			} // end catch
		} // end for

	}

	@GetMapping("/uploadAjax")
	public void uploadAjax() {

		log.info("upload ajax");
	}

	// @PostMapping("/uploadAjaxAction")
	// public void uploadAjaxPost(MultipartFile[] uploadFile) {
	//
	// log.info("update ajax post.........");
	//
	// String uploadFolder = "C:\\upload";
	//
	// for (MultipartFile multipartFile : uploadFile) {
	//
	// log.info("-------------------------------------");
	// log.info("Upload File Name: " + multipartFile.getOriginalFilename());
	// log.info("Upload File Size: " + multipartFile.getSize());
	//
	// String uploadFileName = multipartFile.getOriginalFilename();
	//
	// // IE has file path
	// uploadFileName = uploadFileName.substring(uploadFileName.lastIndexOf("\\") +
	// 1);
	// log.info("only file name: " + uploadFileName);
	//
	// File saveFile = new File(uploadFolder, uploadFileName);
	//
	// try {
	//
	// multipartFile.transferTo(saveFile);
	// } catch (Exception e) {
	// log.error(e.getMessage());
	// } // end catch
	//
	// } // end for
	//
	// }

	//오늘 날짜의 경로를 문자열로 생성, 생생된 경로는 폴더 경로로 수정된 뒤에 반환
	private String getFolder() {

		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");

		Date date = new Date();

		String str = sdf.format(date);

		return str.replace("-", File.separator);
	}

	// @PostMapping("/uploadAjaxAction")
	// public void uploadAjaxPost(MultipartFile[] uploadFile) {
	//
	// String uploadFolder = "C:\\upload";
	//
	// // make folder --------
	// File uploadPath = new File(uploadFolder, getFolder());
	// log.info("upload path: " + uploadPath);
	//
	// if (uploadPath.exists() == false) {
	// uploadPath.mkdirs();
	// }
	// // make yyyy/MM/dd folder
	//
	// for (MultipartFile multipartFile : uploadFile) {
	//
	// log.info("-------------------------------------");
	// log.info("Upload File Name: " + multipartFile.getOriginalFilename());
	// log.info("Upload File Size: " + multipartFile.getSize());
	//
	// String uploadFileName = multipartFile.getOriginalFilename();
	//
	// // IE has file path
	// uploadFileName = uploadFileName.substring(uploadFileName.lastIndexOf("\\") +
	// 1);
	// log.info("only file name: " + uploadFileName);
	//
	// // File saveFile = new File(uploadFolder, uploadFileName);
	// File saveFile = new File(uploadPath, uploadFileName);
	//
	// try {
	//
	// multipartFile.transferTo(saveFile);
	// } catch (Exception e) {
	// log.error(e.getMessage());
	// } // end catch
	//
	// } // end for
	//
	// }

	// @PostMapping("/uploadAjaxAction")
	// public void uploadAjaxPost(MultipartFile[] uploadFile) {
	//
	// String uploadFolder = "C:\\upload";
	//
	// // make folder --------
	// File uploadPath = new File(uploadFolder, getFolder());
	// log.info("upload path: " + uploadPath);
	//
	// if (uploadPath.exists() == false) {
	// uploadPath.mkdirs();
	// }
	// // make yyyy/MM/dd folder
	//
	// for (MultipartFile multipartFile : uploadFile) {
	//
	// log.info("-------------------------------------");
	// log.info("Upload File Name: " + multipartFile.getOriginalFilename());
	// log.info("Upload File Size: " + multipartFile.getSize());
	//
	// String uploadFileName = multipartFile.getOriginalFilename();
	//
	// // IE has file path
	// uploadFileName = uploadFileName.substring(uploadFileName.lastIndexOf("\\") +
	// 1);
	// log.info("only file name: " + uploadFileName);
	//
	// UUID uuid = UUID.randomUUID();
	//
	// uploadFileName = uuid.toString() + "_" + uploadFileName;
	//
	// File saveFile = new File(uploadPath, uploadFileName);
	//
	// try {
	//
	// multipartFile.transferTo(saveFile);
	// } catch (Exception e) {
	// log.error(e.getMessage());
	// } // end catch
	//
	// } // end for
	//
	// }

	//특정한 파일이 이미지 타입인지 검사
	private boolean checkImageType(File file) {

		try {
			String contentType = Files.probeContentType(file.toPath());

			return contentType.startsWith("image");

		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}

		return false;
	}

	// @PostMapping("/uploadAjaxAction")
	// public void uploadAjaxPost(MultipartFile[] uploadFile) {
	//
	// String uploadFolder = "C:\\upload";
	//
	// // make folder --------
	// File uploadPath = new File(uploadFolder, getFolder());
	// log.info("upload path: " + uploadPath);
	//
	// if (uploadPath.exists() == false) {
	// uploadPath.mkdirs();
	// }
	// // make yyyy/MM/dd folder
	//
	// for (MultipartFile multipartFile : uploadFile) {
	//
	// log.info("-------------------------------------");
	// log.info("Upload File Name: " + multipartFile.getOriginalFilename());
	// log.info("Upload File Size: " + multipartFile.getSize());
	//
	// String uploadFileName = multipartFile.getOriginalFilename();
	//
	// // IE has file path
	// uploadFileName = uploadFileName.substring(uploadFileName.lastIndexOf("\\") +
	// 1);
	// log.info("only file name: " + uploadFileName);
	//
	// UUID uuid = UUID.randomUUID();
	//
	// uploadFileName = uuid.toString() + "_" + uploadFileName;
	//
	// try {
	// File saveFile = new File(uploadPath, uploadFileName);
	// multipartFile.transferTo(saveFile);
	// // check image type file
	// if (checkImageType(saveFile)) {
	//
	// FileOutputStream thumbnail = new FileOutputStream(new File(uploadPath, "s_" +
	// uploadFileName));
	//
	// Thumbnailator.createThumbnail(multipartFile.getInputStream(), thumbnail, 100,
	// 100);
	//
	// thumbnail.close();
	// }
	//
	// } catch (Exception e) {
	// e.printStackTrace();
	// } //end catch
	// } // end for
	//
	// }

	@PostMapping(value = "/uploadAjaxAction", produces = MediaType.APPLICATION_JSON_UTF8_VALUE)
	@ResponseBody
	public ResponseEntity<List<AttachFileDTO>> uploadAjaxPost(MultipartFile[] uploadFile) {

		List<AttachFileDTO> list = new ArrayList<>();
		String uploadFolder = "C:\\upload";

		String uploadFolderPath = getFolder();
		// make folder --------
		File uploadPath = new File(uploadFolder, uploadFolderPath);

		if (uploadPath.exists() == false) {
			//mkdirs -> 첨부파일을 보관하는 폴더를 생성할 때, 이걸 쓰면 상위폴더까지 한 번에 생성할 수 있다.
			uploadPath.mkdirs();
		}
		// make yyyy/MM/dd folder

		for (MultipartFile multipartFile : uploadFile) {

			AttachFileDTO attachDTO = new AttachFileDTO();

			String uploadFileName = multipartFile.getOriginalFilename();

			// IE has file path
			uploadFileName = uploadFileName.substring(uploadFileName.lastIndexOf("\\") + 1);
			log.info("only file name: " + uploadFileName);
			attachDTO.setFileName(uploadFileName);

			//중복 방지를 위한  UUID 적용, UUID 클래스를 사용해서 유일한 식별자를 생성
			UUID uuid = UUID.randomUUID();

			//생성된 값은 원래의 파일 이름과 구분할 수 있도록 중간에 '_'를 추가
			uploadFileName = uuid.toString() + "_" + uploadFileName;

			try {
				File saveFile = new File(uploadPath, uploadFileName);
				multipartFile.transferTo(saveFile);

				attachDTO.setUuid(uuid.toString());
				attachDTO.setUploadPath(uploadFolderPath);

				// 특적한 파일이 이미지 타입인지 검사
				if (checkImageType(saveFile)) {

					attachDTO.setImage(true);

					//이미지 타입이라면 파일 이름이 s_로 시작하는 섬네일 파일이 생성, 일반 파일의 경우 그냥 파일만 업로드
					FileOutputStream thumbnail = new FileOutputStream(new File(uploadPath, "s_" + uploadFileName));
					
					Thumbnailator.createThumbnail(multipartFile.getInputStream(), thumbnail, 100, 100);

					thumbnail.close();
				}

				list.add(attachDTO);

			} catch (Exception e) {
				e.printStackTrace();
			}

		} // end for
		return new ResponseEntity<>(list, HttpStatus.OK);
	}

	//썸네일은 서버를 통해서 특정 URI를 호출하면 보여줄 수 있도록 처리하는데, 해당 파일의 경로와 UUID가 붙은 파일의 이름이 필요..
	//GET방식을 통해서 가져올 수 있도록 처리, 특정한 URI뒤에 파일 이름을 추가하면 이미지 파일 데이터를 가져와서 <img> 태그르 작성하는 과정을 통해서 처리
	@GetMapping("/display")
	@ResponseBody
	public ResponseEntity<byte[]> getFile(String fileName) {

		log.info("fileName: " + fileName);

		File file = new File("c:\\upload\\" + fileName);

		log.info("file: " + file);

		ResponseEntity<byte[]> result = null;

		try {
			HttpHeaders header = new HttpHeaders();
			//파일의 확장자에 따라서 MIME타입이 다르게 처리
			header.add("Content-Type", Files.probeContentType(file.toPath()));
			result = new ResponseEntity<>(FileCopyUtils.copyToByteArray(file), header, HttpStatus.OK);
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return result;
	}

	// @GetMapping(value = "/download", produces =
	// MediaType.APPLICATION_OCTET_STREAM_VALUE)
	// @ResponseBody
	// public ResponseEntity<Resource> downloadFile(String fileName) {
	//
	// log.info("download file: " + fileName);
	//
	// Resource resource = new FileSystemResource("c:\\upload\\" + fileName);
	//
	// log.info("resource: " + resource);
	//
	// return null;
	// }

	// @GetMapping(value = "/download", produces =
	// MediaType.APPLICATION_OCTET_STREAM_VALUE)
	// @ResponseBody
	// public ResponseEntity<Resource> downloadFile(String fileName) {
	//
	// log.info("download file: " + fileName);
	//
	// Resource resource = new FileSystemResource("c:\\upload\\" + fileName);
	//
	// log.info("resource: " + resource);
	//
	// String resourceName = resource.getFilename();
	//
	// HttpHeaders headers = new HttpHeaders();
	// try {
	// headers.add("Content-Disposition",
	// "attachment; filename=" + new String(resourceName.getBytes("UTF-8"),
	// "ISO-8859-1"));
	// } catch (UnsupportedEncodingException e) {
	// e.printStackTrace();
	// }
	// return new ResponseEntity<Resource>(resource, headers, HttpStatus.OK);
	// }

	// @GetMapping(value="/download" ,
	// produces=MediaType.APPLICATION_OCTET_STREAM_VALUE)
	// @ResponseBody
	// public ResponseEntity<Resource>
	// downloadFile(@RequestHeader("User-Agent")String userAgent, String fileName){
	//
	// Resource resource = new FileSystemResource("c:\\upload\\" + fileName);
	//
	// if(resource.exists() == false) {
	// return new ResponseEntity<>(HttpStatus.NOT_FOUND);
	// }
	//
	// String resourceName = resource.getFilename();
	//
	// HttpHeaders headers = new HttpHeaders();
	// try {
	//
	// boolean checkIE = (userAgent.indexOf("MSIE") > -1 ||
	// userAgent.indexOf("Trident") > -1);
	//
	// String downloadName = null;
	//
	// if (checkIE) {
	// downloadName = URLEncoder.encode(resourceName, "UTF8").replaceAll("\\+", "
	// ");
	// } else {
	// downloadName = new String(resourceName.getBytes("UTF-8"), "ISO-8859-1");
	// }
	//
	// headers.add("Content-Disposition", "attachment; filename=" + downloadName);
	//
	// } catch (UnsupportedEncodingException e) {
	// e.printStackTrace();
	// }
	//
	// return new ResponseEntity<Resource>(resource, headers, HttpStatus.OK);
	// }

	// @GetMapping(value="/download" ,
	// produces=MediaType.APPLICATION_OCTET_STREAM_VALUE)
	// @ResponseBody
	// public ResponseEntity<Resource>
	// downloadFile(@RequestHeader("User-Agent")String userAgent, String fileName){
	//
	// Resource resource = new FileSystemResource("c:\\upload\\" + fileName);
	//
	// if(resource.exists() == false) {
	// return new ResponseEntity<>(HttpStatus.NOT_FOUND);
	// }
	//
	// String resourceName = resource.getFilename();
	//
	// //remove UUID
	// String resourceOriginalName =
	// resourceName.substring(resourceName.indexOf("_")+1);
	//
	// HttpHeaders headers = new HttpHeaders();
	// try {
	//
	// boolean checkIE = (userAgent.indexOf("MSIE") > -1 ||
	// userAgent.indexOf("Trident") > -1);
	//
	// String downloadName = null;
	//
	// if(checkIE) {
	// downloadName = URLEncoder.encode(resourceOriginalName,
	// "UTF8").replaceAll("\\+", " ");
	// }else {
	// downloadName = new
	// String(resourceOriginalName.getBytes("UTF-8"),"ISO-8859-1");
	// }
	//
	// headers.add("Content-Disposition", "attachment; filename="+downloadName);
	//
	// } catch (UnsupportedEncodingException e) {
	// e.printStackTrace();
	// }
	//
	// return new ResponseEntity<Resource>(resource, headers,HttpStatus.OK);
	// }

	
	//MIME타입은 다운로드할 수 있는 APPLICATION_OCTET으로 지정하고, 다운로드 시 저장되는 이름은 content-disposition을 이요해서 처리
	//User-Agentsms IE를 서비스 하기위해 사용, 디바이스의 정보를 알 수 있는 헤더임(모바일인지 데스크톱인지)
	@GetMapping(value = "/download", produces = MediaType.APPLICATION_OCTET_STREAM_VALUE)
	@ResponseBody
	public ResponseEntity<Resource> downloadFile(@RequestHeader("User-Agent") String userAgent, String fileName) {

		Resource resource = new FileSystemResource("c:\\upload\\" + fileName);

		if (resource.exists() == false) {
			return new ResponseEntity<>(HttpStatus.NOT_FOUND);
		}

		String resourceName = resource.getFilename();

		// remove UUID -> 서버에서 파일 이름에 UUID가 붙은 부분을 제거하고 순수하게 다운로드되는 파일의 이름으로 저장될 수 있도록
		String resourceOriginalName = resourceName.substring(resourceName.indexOf("_") + 1);
		
		// 다운로드 시 파일의 이름을 처리하도록 HttpHeaders를 사용
		HttpHeaders headers = new HttpHeaders();
		try {
			//Trident는 IE브라우저의 엔진 이름
			boolean checkIE = (userAgent.indexOf("MSIE") > -1 || userAgent.indexOf("Trident") > -1);

			String downloadName = null;

			if (checkIE) {
				downloadName = URLEncoder.encode(resourceOriginalName, "UTF8").replaceAll("\\+", " ");
			} else {
				downloadName = new String(resourceOriginalName.getBytes("UTF-8"), "ISO-8859-1");
			}
			//Content-Disposition: 파일이름에 대한 문자열 처리는 파일 이름이 한글인 경우 저장할 때 깨지는 문제를 해결하기 위해
			headers.add("Content-Disposition", "attachment; filename=" + downloadName);

		} catch (UnsupportedEncodingException e) {
			e.printStackTrace();
		}

		return new ResponseEntity<Resource>(resource, headers, HttpStatus.OK);
	}
	

	//서버 측에서 첨부파일은 전다로디는 파라미터의 이름과 종류를 파악해서 처리
	@PostMapping("/deleteFile")
	@ResponseBody
	public ResponseEntity<String> deleteFile(String fileName, String type) {
		
		log.info("deleteFile: " + fileName);
		File file;
		try {
			file = new File("c:\\upload\\" + URLDecoder.decode(fileName, "UTF-8"));
			file.delete();

			if (type.equals("image")) {
				//원본 이미지 파일도 같이 삭제하도록 처리
				String largeFileName = file.getAbsolutePath().replace("s_", "");
				log.info("largeFileName: " + largeFileName);
				file = new File(largeFileName);
				file.delete();
			}
		} catch (UnsupportedEncodingException e) {
			e.printStackTrace();
			return new ResponseEntity<>(HttpStatus.NOT_FOUND);
		}

		return new ResponseEntity<String>("deleted", HttpStatus.OK);
	}
	

}
