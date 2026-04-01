package nl.cinq.devops.api.controller;

import java.util.Random;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/v1")
public class ValueController {
  @GetMapping("/int")
  public int getRandomInt() {
    final Random pseudo = new Random();
    return pseudo.nextInt();
  }
}