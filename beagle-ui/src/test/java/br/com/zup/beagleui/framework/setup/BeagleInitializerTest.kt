package br.com.zup.beagleui.framework.setup

import android.app.Application
import android.content.Intent
import br.com.zup.beagleui.framework.mockdata.CustomWidget
import br.com.zup.beagleui.framework.mockdata.CustomWidgetFactory
import br.com.zup.beagleui.framework.navigation.BeagleDeepLinkHandler
import br.com.zup.beagleui.framework.networking.URLRequestDispatching
import br.com.zup.beagleui.framework.widget.core.NativeWidget
import br.com.zup.beagleui.framework.widget.navigation.DeeplinkURL
import io.mockk.MockKAnnotations
import io.mockk.Runs
import io.mockk.every
import io.mockk.impl.annotations.MockK
import io.mockk.just
import io.mockk.mockkObject
import io.mockk.unmockkObject
import io.mockk.verify
import org.junit.After
import org.junit.Before
import org.junit.Test
import kotlin.test.assertEquals
import kotlin.test.assertNotNull

private const val APP_NAME = "beagle"

class BeagleInitializerTest {

    @MockK
    private lateinit var application: Application

    @MockK
    private lateinit var buttonTheme: ButtonTheme

    @MockK
    private lateinit var textAppearanceTheme: TextAppearanceTheme

    @MockK
    private lateinit var intent: Intent

    private lateinit var theme: Theme

    private var beagleDeepLinkHandler: BeagleDeepLinkHandler = object : BeagleDeepLinkHandler {
        override fun getDeepLinkIntent(deepLinkURL: DeeplinkURL): Intent = intent
    }

    @MockK
    private lateinit var networkingDispatcher: URLRequestDispatching

    @Before
    fun setUp() {
        MockKAnnotations.init(this)

        mockkObject(BeagleEnvironment)

        every { BeagleEnvironment.setup(any(), any()) } just Runs
        every {
            BeagleEnvironment.registerWidget(
                any<Class<NativeWidget>>(),
                any()
            )
        } just Runs
    }

    @After
    fun after() {
        unmockkObject(BeagleEnvironment)
        BeagleEnvironment.theme = null
        BeagleEnvironment.networkingDispatcher = null
    }

    @Test
    fun setup_should_call_BeagleEnvironment_setup() {
        BeagleInitializer.setup(APP_NAME, application)

        verify(exactly = 1) { BeagleEnvironment.setup(APP_NAME, application) }
    }

    @Test
    fun registerWidget_should_call_BeagleEnvironment_registerWidget() {
        // Given
        val button = CustomWidget::class.java
        val factory = CustomWidgetFactory()

        // When
        BeagleInitializer.registerWidget(button, factory)

        // Then
        verify(exactly = 1) { BeagleEnvironment.registerWidget(button, factory) }
    }

    @Test
    fun beagleDeepLinkHandler_should_call_BeagleEnvironment_beagleDeepLinkHandler() {

        // When
        BeagleInitializer.registerBeagleDeepLinkHandler(beagleDeepLinkHandler)

        // Then
        assertNotNull(BeagleEnvironment.beagleDeepLinkHandler)
        assertEquals(beagleDeepLinkHandler, BeagleEnvironment.beagleDeepLinkHandler)
    }

    @Test
    fun registerTheme_should_call_BeagleEnvironment_registerTheme() {
        theme = Theme(
            buttonTheme = buttonTheme,
            textAppearanceTheme = textAppearanceTheme
        )
        // When
        BeagleInitializer.registerTheme(theme = theme)

        // Then
        assertNotNull(BeagleEnvironment.theme)
        assertEquals(theme, BeagleEnvironment.theme)
        assertEquals(theme.buttonTheme, BeagleEnvironment.theme?.buttonTheme)
        assertEquals(theme.textAppearanceTheme, BeagleEnvironment.theme?.textAppearanceTheme)
    }

    @Test
    fun registerNetworkingDispatcher_should_call_BeagleEnvironment_registerNetworkingDispatcher() {

        // When
        BeagleInitializer.registerNetworkingDispatcher(networkingDispatcher = networkingDispatcher)

        // Then
        assertNotNull(BeagleEnvironment.networkingDispatcher)
        assertEquals(networkingDispatcher, BeagleEnvironment.networkingDispatcher)
    }
}
