# 🧢 Tienda E-commerce "New Era" (Proyecto ASP.NET)

Este es un proyecto E-commerce para una tienda de gorras, construido con **ASP.NET** y una **arquitectura en N-Capas**.  
Incluye un **Dashboard de administración** y una **tienda para clientes** con integración de pagos a través de **PayPal Sandbox**.

---

## 🛠️ Tecnologías Utilizadas

- **Framework:** ASP.NET  
- **Lenguaje:** C#  
- **Base de Datos:** Microsoft SQL Server  
- **Pagos:** API de PayPal Sandbox  
- **Arquitectura:** N-Capas (CapaDatos, CapaEntidad, CapaNegocio, CapaPresentacion)

---

## 🚀 Puesta en Marcha y Configuración

Siga estos pasos en orden para configurar y ejecutar el proyecto localmente.

### 1️⃣ Clonar el Repositorio

```bash
git clone [https](https://github.com/LautaAp23/Proyecto-eccomerce-lenguajes-3-y-4.git)://github.com/tu-usuario/tu-repositorio.git
cd Proyecto-eccomerce-lenguajes-3-y-4
```

> 💡 *https://github.com/LautaAp23/Proyecto-eccomerce-lenguajes-3-y-4.git*

---

### 2️⃣ Configuración de la Base de Datos

1. **Restaurar la Base de Datos:**
   - Busque el archivo `bdd-new-era.sql` en la raíz del proyecto.
   - Ejecute el script completo en su instancia de **SQL Server** (puede usar *SQL Server Management Studio* o una herramienta similar).
   - Esto creará la base de datos **`newera`** con todas las tablas, procedimientos almacenados y datos de ejemplo.

2. **Configurar la Cadena de Conexión:**
   - Abra la solución (`.sln`) en **Visual Studio**.
   - Vaya al proyecto **`CapaPresentacionTienda`**.
   - Ajuste la `connectionString` en el archivo `Web.config` para que apunte a su instancia local de SQL Server.  
     Por ejemplo:

     ```xml
     <connectionStrings>
       <add name="cadena" connectionString="data source=LAPTOP-QTBI25E3\SQLEXPRESS;initial catalog=newera;integrated security=True" providerName="System.Data.SqlClient" />
     </connectionStrings>
     ```

---

### 3️⃣ Configuración de Claves (PayPal)

Este proyecto utiliza un archivo **`secrets.config`** (que no se sube a GitHub) para proteger las credenciales de la API de PayPal.

1. En el proyecto **`CapaPresentacionTienda`**, haga clic derecho → **Agregar → Nuevo Elemento**.
2. Cree un archivo XML o de texto llamado **`secrets.config`**.
3. Pegue el siguiente contenido, reemplazando con sus propias claves de **PayPal Sandbox**:

   ```xml
   <appSettings>
     <add key="urlPaypal" value="https://api-m.sandbox.paypal.com" />
     <add key="ClientId" value="TU_CLIENT_ID_DE_PAYPAL" />
     <add key="Secret" value="TU_SECRET_KEY_DE_PAYPAL" />

     <add key="webpages:Version" value="3.0.0.0" />
     <add key="webpages:Enabled" value="false" />
     <add key="ClientValidationEnabled" value="true" />
     <add key="UnobtrusiveJavaScriptEnabled" value="true" />
   </appSettings>
   ```

4. Asegúrese de que su archivo `Web.config` principal incluya esta línea para leer las claves:

   ```xml
   <appSettings file="secrets.config"></appSettings>
   ```

---

### 4️⃣ Configuración de Imágenes (⚠️ Importante)

La base de datos está configurada para leer las imágenes de los productos desde una **ruta de disco local absoluta**.  
Para que las imágenes se muestren correctamente:

1. Vaya a la raíz de su disco `C:`.
2. Cree una carpeta llamada **`fotos_gorras`**.
3. La ruta exacta debe ser:  
   ```
   C:\fotos_gorras
   ```
4. Coloque dentro todas las imágenes de los productos (por ejemplo: `4.jpg`, `5.jpg`, `6.jpg`, ...).

> ⚠️ **Advertencia:**  
> El proyecto **no mostrará imágenes** si esta carpeta no existe o está en otra ubicación.  
> Este método funciona solo en el entorno de desarrollo local y debe ajustarse si se despliega en un servidor web.

---

## 🏃‍♀️ Ejecutar el Proyecto

Una vez completados todos los pasos de configuración:

1. Establezca **`CapaPresentacionTienda`** (o el proyecto correspondiente) como **Proyecto de Inicio**.
2. Presione **F5** o el botón **Iniciar** en Visual Studio para compilar y ejecutar la aplicación.
3. La aplicación abrirá la tienda en el navegador predeterminado.

---

## 📂 Estructura del Proyecto

```
📦 TiendaNewEra
 ┣ 📂 CapaDatos
 ┣ 📂 CapaEntidad
 ┣ 📂 CapaNegocio
 ┣ 📂 CapaPresentacionDashboard
 ┣ 📂 CapaPresentacionTienda
 ┣ 📜 bdd-new-era.sql
 ┗ 📜 README.md
```

---

## 📸 Capturas (opcional)

> *(Puede agregar aquí imágenes de la interfaz de la tienda y del dashboard de administración.)*

---

## 🧑‍💻 Autor

**Desarrollado por:** *Lautaro Aponte*  
**GitHub:** (https://github.com/LautaAp23)

---

## ⚖️ Licencia

Este proyecto se distribuye bajo la licencia **MIT**, lo que permite su uso, modificación y distribución libremente.

---

✨ *Proyecto educativo desarrollado con fines de práctica y demostración.*
