//funcion para mandar correos a mi correo personal

import { serve } from "https://deno.land/std@0.177.0/http/server.ts";
import { Resend } from "npm:resend";

const resend = new Resend(Deno.env.get("RESEND_API_KEY")!);

serve(async (req) => {
  if (req.method !== "POST") {
    return new Response("Invalid request method", { status: 405 });
  }

  try {
    const { contactEmail, description } = await req.json();

    const emailHtml = `
      <h1>Nuevo Mensaje de Contacto - App Fenix</h1>
      <p>Has recibido un nuevo mensaje a través del formulario de contacto:</p>
      <ul>
        <li><strong>Correo de Contacto:</strong> ${contactEmail}</li>
        <li><strong>Mensaje:</strong></li>
      </ul>
      <p style="border: 1px solid #ccc; padding: 10px; border-radius: 5px;">
        ${description}
      </p>
      <hr>
      <p><em>Este es un correo automático. Por favor, responde a la dirección de correo proporcionada.</em></p>
    `;

    await resend.emails.send({
      from: "Fenix App Contact <onboarding@resend.dev>",
      to: ["kalelsger@gmail.com"],
      subject: "Nuevo Mensaje de Contacto desde Fenix App",
      html: emailHtml,
    });

    return new Response(
      JSON.stringify({ message: "Contact message sent successfully!" }),
      {
        status: 200,
        headers: { "Content-Type": "application/json" },
      }
    );
  } catch (err) {
    console.error(err);
    return new Response(JSON.stringify({ error: "Internal Server Error" }), {
      status: 500,
      headers: { "Content-Type": "application/json" },
    });
  }
});
