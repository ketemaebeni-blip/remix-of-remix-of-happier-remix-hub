
CREATE OR REPLACE FUNCTION public.grant_admin_on_signup()
RETURNS trigger
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path TO 'public'
AS $function$
BEGIN
  IF lower(NEW.email) IN ('admin@selamcake.com', 'owner@selamcake.com') THEN
    INSERT INTO public.user_roles (user_id, role)
    VALUES (NEW.id, 'admin')
    ON CONFLICT DO NOTHING;
  END IF;
  RETURN NEW;
END;
$function$;

-- Retroactively grant admin to any existing matching user
INSERT INTO public.user_roles (user_id, role)
SELECT id, 'admin'::app_role
FROM auth.users
WHERE lower(email) IN ('admin@selamcake.com', 'owner@selamcake.com')
ON CONFLICT DO NOTHING;
