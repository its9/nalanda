package com.nalanda.api.feature.platform;

import java.util.Map;

import static org.junit.jupiter.api.Assertions.assertEquals;
import org.junit.jupiter.api.Test;

import com.nalanda.api.platform.PlatformRouteController;

class PlatformRouteControllerTest {

    @Test
    void rootEndpointReturnsApplicationInfo() {
        PlatformRouteController controller = new PlatformRouteController();

        Map<String, Object> response = controller.root();

        assertEquals("Nalanda Backend API", response.get("name"));
        assertEquals("OK", response.get("status"));
    }
}
