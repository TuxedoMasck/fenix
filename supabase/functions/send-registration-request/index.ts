    import { serve } from 'https://deno.land/std@0.177.0/http/server.ts'
    import { Resend } from 'npm:resend'

    // Inicializa Resend con la clave que guardaste en los secretos
    const resend = new Resend(Deno.env.get('RESEND_API_KEY')!)

    serve(async (req) => {
      // 1. Validar que la petición sea correcta
      if (req.method !== 'POST' || req.headers.get('content-type') !== 'application/json') {
        return new Response(JSON.stringify({ error: 'Invalid request' }), {
          status: 400,
          headers: { 'Content-Type': 'application/json' },
        })
      }

      try {
        // 2. Obtener los datos del registro que envía la app de Flutter
        const { fullName, institutionalEmail, uamId, department, pdfUrl } = await req.json()

        // 3. Construir el cuerpo del correo en HTML
        const emailHtml = `
          <h1>Nueva Solicitud de Registro - App Fenix</h1>
          <p>Se ha recibido una nueva solicitud con los siguientes datos:</p>
          <ul>
            <li><strong>Nombre Completo:</strong> ${fullName}</li>
            <li><strong>Correo Institucional:</strong> ${institutionalEmail}</li>
            <li><strong>Matrícula/No. Empleado:</strong> ${uamId}</li>
            <li><strong>División/Departamento:</strong> ${department}</li>
          </ul>
          <p>La credencial adjunta se puede ver en el siguiente enlace:</p>
          <p><a href="${pdfUrl}">Ver Credencial en PDF</a></p>
          <hr>
          <p><em>Este es un correo automático. Para aprobar al usuario, debes crear su cuenta manualmente en la base de datos de Supabase.</em></p>
        `;

        // 4. Enviar el correo usando Resend
        const { data, error } = await resend.emails.send({
          from: 'Fenix App <onboarding@resend.dev>', // Requerido por Resend.
          to: ['kalelsger@gmail.com'], // ¡Tu correo!
          subject: `Nueva Solicitud de Registro: ${fullName}`,
          html: emailHtml,
        });

        if (error) {
          console.error({ error })
          return new Response(JSON.stringify({ error: 'Failed to send email' }), {
            status: 500,
            headers: { 'Content-Type': 'application/json' },
          })
        }

        // 5. Devolver una respuesta de éxito a la app de Flutter
        return new Response(JSON.stringify({ message: 'Email sent successfully!' }), {
          status: 200,
          headers: { 'Content-Type': 'application/json' },
        })

      } catch (err) {
        console.error(err)
        return new Response(JSON.stringify({ error: 'Internal Server Error' }), {
          status: 500,
          headers: { 'Content-Type': 'application/json' },
        })
      }
    })
