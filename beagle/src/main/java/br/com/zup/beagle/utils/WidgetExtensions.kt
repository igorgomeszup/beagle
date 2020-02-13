package br.com.zup.beagle.utils

import android.content.Context
import androidx.appcompat.app.AppCompatActivity
import androidx.fragment.app.Fragment
import br.com.zup.beagle.core.ServerDrivenComponent
import br.com.zup.beagle.engine.renderer.ActivityRootView
import br.com.zup.beagle.engine.renderer.FragmentRootView
import br.com.zup.beagle.engine.renderer.RootView
import br.com.zup.beagle.engine.renderer.ViewRendererFactory
import br.com.zup.beagle.widget.layout.Screen
import br.com.zup.beagle.widget.layout.ScreenComponent

internal var viewRenderer = ViewRendererFactory()

fun ServerDrivenComponent.toView(context: Context) = this.toView(context as AppCompatActivity)

fun ServerDrivenComponent.toView(activity: AppCompatActivity) =
    this.toView(ActivityRootView(activity))

fun ServerDrivenComponent.toView(fragment: Fragment) = this.toView(FragmentRootView(fragment))

fun Screen.toView(activity: AppCompatActivity) = this.toComponent().toView(activity)

fun Screen.toView(fragment: Fragment) = this.toComponent().toView(fragment)

internal fun Screen.toComponent() = ScreenComponent(
    navigationBar = this.navigationBar,
    header = this.header,
    content = this.content,
    footer = this.footer
)

internal fun ServerDrivenComponent.toView(rootView: RootView) =
    viewRenderer.make(this).build(rootView)
