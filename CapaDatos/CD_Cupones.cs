using CapaEntidad;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Globalization;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CapaDatos
{
    public class CD_Cupones
    {
        public List<Cupones> Listar()
        {
            List<Cupones> lista = new List<Cupones>();

            try
            {
                using (SqlConnection oconexion = new SqlConnection(Conexion.cn))
                {
                    string query = @"SELECT IdCupones, Codigo_cupon, TipoDescuento, 
                                    Porcentaje_desc_cup, Monto_desc_cup, 
                                    Cantidad_cup, Fecha_Vencimiento, Activo 
                             FROM CUPONES";

                    SqlCommand cmd = new SqlCommand(query, oconexion);
                    cmd.CommandType = CommandType.Text;

                    oconexion.Open();

                    using (SqlDataReader dr = cmd.ExecuteReader())
                    {
                        while (dr.Read())
                        {
                            lista.Add(new Cupones()
                            {
                                IdCupones = Convert.ToInt32(dr["IdCupones"]),
                                Codigo_cupon = dr["Codigo_cupon"].ToString(),
                                TipoDescuento = dr["TipoDescuento"].ToString(),
                                Porcentaje_desc_cup = dr["Porcentaje_desc_cup"] != DBNull.Value ? Convert.ToDecimal(dr["Porcentaje_desc_cup"]) : 0,
                                Monto_desc_cup = dr["Monto_desc_cup"] != DBNull.Value ? Convert.ToDecimal(dr["Monto_desc_cup"]) : 0,
                                Cantidad_cup = Convert.ToInt32(dr["Cantidad_cup"]),
                                Fecha_Vencimiento = Convert.ToDateTime(dr["Fecha_Vencimiento"]),
                                Activo = Convert.ToBoolean(dr["Activo"])
                            });
                        }
                    }
                }
            }
            catch
            {
                lista = new List<Cupones>();
            }

            return lista;
        }





        public int Registrar(Cupones obj, out string Mensaje)
        {
            int idautogenerado = 0;

            Mensaje = string.Empty;

            try
            {
                using (SqlConnection oconexion = new SqlConnection(Conexion.cn))
                {
                    SqlCommand cmd = new SqlCommand("sp_RegistrarCupon", oconexion);
                    cmd.Parameters.AddWithValue("Codigo_cupon", obj.Codigo_cupon);
                    cmd.Parameters.AddWithValue("TipoDescuento", obj.TipoDescuento);
                    cmd.Parameters.AddWithValue("Porcentaje_desc_cup", obj.Porcentaje_desc_cup);
                    cmd.Parameters.AddWithValue("Monto_desc_cup", obj.Monto_desc_cup);
                    cmd.Parameters.AddWithValue("Cantidad_cup", obj.@Cantidad_cup);
                    cmd.Parameters.AddWithValue("Fecha_Vencimiento", obj.Fecha_Vencimiento);
                    cmd.Parameters.AddWithValue("Activo", obj.Activo);
                    cmd.Parameters.Add("Resultado", SqlDbType.Int).Direction = ParameterDirection.Output;
                    cmd.Parameters.Add("Mensaje", SqlDbType.VarChar, 500).Direction = ParameterDirection.Output;
                    cmd.CommandType = CommandType.StoredProcedure;

                    oconexion.Open();

                    cmd.ExecuteNonQuery();

                    idautogenerado = Convert.ToInt32(cmd.Parameters["Resultado"].Value);
                    Mensaje = cmd.Parameters["Mensaje"].Value.ToString();
                }
            }
            catch (Exception ex)
            {
                idautogenerado = 0;
                Mensaje = ex.Message;
            }

            return idautogenerado;
        }

        public bool Editar(Cupones obj, out string Mensaje)
        {
            bool resultado = false;
            Mensaje = string.Empty;
            try
            {
                using (SqlConnection oconexion = new SqlConnection(Conexion.cn))
                {
                    SqlCommand cmd = new SqlCommand("sp_EditarCupon", oconexion);
                    cmd.Parameters.AddWithValue("IdCupones", obj.IdCupones);
                    cmd.Parameters.AddWithValue("Codigo_cupon", obj.Codigo_cupon);
                    cmd.Parameters.AddWithValue("TipoDescuento", obj.TipoDescuento);
                    cmd.Parameters.AddWithValue("Porcentaje_desc_cup", obj.Porcentaje_desc_cup);
                    cmd.Parameters.AddWithValue("Monto_desc_cup ", obj.Monto_desc_cup);
                    cmd.Parameters.AddWithValue("Cantidad_cup", obj.Cantidad_cup);
                    cmd.Parameters.AddWithValue("Fecha_Vencimiento", obj.Fecha_Vencimiento);
                    cmd.Parameters.AddWithValue("Activo", obj.Activo);
                    cmd.Parameters.Add("Resultado", SqlDbType.Bit).Direction = ParameterDirection.Output;
                    cmd.Parameters.Add("Mensaje", SqlDbType.VarChar, 500).Direction = ParameterDirection.Output;
                    cmd.CommandType = CommandType.StoredProcedure;

                    oconexion.Open();

                    cmd.ExecuteNonQuery();

                    resultado = Convert.ToBoolean(cmd.Parameters["Resultado"].Value);
                    Mensaje = cmd.Parameters["Mensaje"].Value.ToString();
                }
            }
            catch (Exception ex)
            {
                resultado = false;
                Mensaje = ex.Message;
            }
            return resultado;
        }


        public bool Eliminar(int id, out string Mensaje)
        {
            bool resultado = false;
            Mensaje = string.Empty;
            try
            {
                using (SqlConnection oconexion = new SqlConnection(Conexion.cn))
                {
                    SqlCommand cmd = new SqlCommand("sp_EliminarCupon", oconexion);
                    cmd.Parameters.AddWithValue("IdCupones", id);
                    cmd.Parameters.Add("Resultado", SqlDbType.Bit).Direction = ParameterDirection.Output;
                    cmd.Parameters.Add("Mensaje", SqlDbType.VarChar, 500).Direction = ParameterDirection.Output;
                    cmd.CommandType = CommandType.StoredProcedure;

                    oconexion.Open();

                    cmd.ExecuteNonQuery();

                    resultado = Convert.ToBoolean(cmd.Parameters["Resultado"].Value);
                    Mensaje = cmd.Parameters["Mensaje"].Value.ToString();

                }
            }
            catch (Exception ex)
            {
                resultado = false;
                Mensaje = ex.Message;
            }
            return resultado;
        }

        public bool Validar(string codigo_cupon, out string Mensaje,
            out decimal montoDescuento,
            out decimal porcentajeDescuento,
            out string tipoDescuento,
            out int IdCupones)
        {
            bool resultado = false;

            // Inicializar variables de salida
            Mensaje = string.Empty;
            montoDescuento = 0;
            porcentajeDescuento = 0;
            tipoDescuento = string.Empty;
            IdCupones = 0;

            try
            {
                using (SqlConnection oconexion = new SqlConnection(Conexion.cn))
                {
                    SqlCommand cmd = new SqlCommand("usp_ValidarCupon", oconexion);
                    cmd.CommandType = CommandType.StoredProcedure;

                    // Parámetros de entrada
                    cmd.Parameters.AddWithValue("@Codigocupon", codigo_cupon);

                    // Parámetros de salida
                    cmd.Parameters.Add("@MontoDescuento", SqlDbType.Decimal).Precision = 10;
                    cmd.Parameters["@MontoDescuento"].Scale = 2;
                    cmd.Parameters["@MontoDescuento"].Direction = ParameterDirection.Output;

                    cmd.Parameters.Add("@PorcentajeDescuento", SqlDbType.Decimal).Precision = 5;
                    cmd.Parameters["@PorcentajeDescuento"].Scale = 2;
                    cmd.Parameters["@PorcentajeDescuento"].Direction = ParameterDirection.Output;

                    cmd.Parameters.Add("@TipoDescuento", SqlDbType.VarChar, 20).Direction = ParameterDirection.Output;
                    cmd.Parameters.Add("@IdCupon", SqlDbType.Int).Direction = ParameterDirection.Output; // Nuevo
                    cmd.Parameters.Add("@Mensaje", SqlDbType.VarChar, 200).Direction = ParameterDirection.Output;
                    cmd.Parameters.Add("@Resultado", SqlDbType.Bit).Direction = ParameterDirection.Output;

                    // Ejecutar
                    oconexion.Open();
                    cmd.ExecuteNonQuery();

                    // Obtener resultados
                    resultado = Convert.ToBoolean(cmd.Parameters["@Resultado"].Value);
                    Mensaje = cmd.Parameters["@Mensaje"].Value.ToString();

                    if (resultado)
                    {
                        montoDescuento = Convert.ToDecimal(cmd.Parameters["@MontoDescuento"].Value);
                        porcentajeDescuento = Convert.ToDecimal(cmd.Parameters["@PorcentajeDescuento"].Value);
                        tipoDescuento = cmd.Parameters["@TipoDescuento"].Value.ToString();
                        IdCupones = Convert.ToInt32(cmd.Parameters["@IdCupon"].Value); // Leer el ID
                    }
                }
            }
            catch (Exception ex)
            {
                resultado = false;
                Mensaje = "Error: " + ex.Message;
            }

            return resultado;
        }




    }
}
