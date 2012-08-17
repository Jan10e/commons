%{
common.TpSession (manual) # two-photon session (same objective, same base path)

-> common.Animal
tp_session      : smallint              # session index
---
tp_session_date             : date                          # 
data_path                   : varchar(255)                  # root file path
basename="scan"             : varchar(80)                   # scanimage base filename name
lens                        : enum('10x','16x','20x','25x','40x','60x')# objective lens
fov                         : float                         # (um) across the full FOV at mag = 1.0
anesthesia="other"          : enum('isoflurane','fentanyl','urethane','other')# per protocol
tp_session_notes=""         : varchar(4095)                 # free-text notes
tp_ts=CURRENT_TIMESTAMP     : timestamp                     # automatic
%}

classdef TpSession < dj.Relvar

	properties(Constant)
		table = dj.Table('common.TpSession')
	end

	methods
		function self = TpSession(varargin)
			self.restrict(varargin)
		end
	end
end
