package br.com.zup.beagle.annotation

@Target(AnnotationTarget.CLASS)
@Retention(AnnotationRetention.RUNTIME)
annotation class RegisterValidator(
    val name: String
)