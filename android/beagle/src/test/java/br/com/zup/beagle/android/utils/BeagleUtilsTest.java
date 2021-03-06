/*
 * Copyright 2020 ZUP IT SERVICOS EM TECNOLOGIA E INOVACAO SA
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

package br.com.zup.beagle.android.utils;

import org.junit.jupiter.api.Test;

import static org.junit.Assert.assertEquals;

public class BeagleUtilsTest {

    @Test
    public void toAndroidId_should_return_3546_when_value_is_oi() {
        // Given
        final String myId = "oi";

        // When
        final int result = BeagleUtils.toAndroidId(myId);

        // Then
        assertEquals(3546, result);
    }
}
