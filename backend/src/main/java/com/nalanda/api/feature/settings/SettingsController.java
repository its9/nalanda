package com.nalanda.api.feature.settings;

import java.util.Map;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/settings")
public class SettingsController {

    private final SettingsService service;

    public SettingsController(SettingsService service) {
        this.service = service;
    }

    @GetMapping
    public SettingsResponse list() {
        return service.get("general");
    }

    @PutMapping
    public SettingsResponse update(@RequestBody Map<String, Object> values) {
        return service.update("general", values);
    }

    @GetMapping("/{scope}")
    public SettingsResponse getScope(@PathVariable String scope) {
        return service.get(scope);
    }

    @PutMapping("/{scope}")
    public SettingsResponse updateScope(@PathVariable String scope,
                                        @RequestBody Map<String, Object> values) {
        return service.update(scope, values);
    }
}