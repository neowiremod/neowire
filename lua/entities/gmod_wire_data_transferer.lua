AddCSLuaFile()
DEFINE_BASECLASS( "base_wire_entity" )
ENT.PrintName       = "Wire Data Transferer"
ENT.RenderGroup		= RENDERGROUP_BOTH
ENT.WireDebugName	= "Data Transferer"

function ENT:SetupDataTables()
	self:NetworkVar( "Float", 0, "BeamLength" )
end

if CLIENT then return end -- No more client

function ENT:Initialize()
	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )
	self.Inputs = WireLib.CreateInputs(self, {"Send","Range","A","B","C","D","E","F","G","H"})
	self.Outputs = WireLib.CreateOutputs(self, {"A","B","C","D","E","F","G","H"})
	self.Sending = false
	self.Activated = false
	self.ActivateTime = 0
	self.DefaultZero = true
	self.IgnoreZero = false
	self.Values = {};
	self.Values["A"] = 0
	self.Values["B"] = 0
	self.Values["C"] = 0
	self.Values["D"] = 0
	self.Values["E"] = 0
	self.Values["F"] = 0
	self.Values["G"] = 0
	self.Values["H"] = 0

	self:SetBeamLength(25000)
end

function ENT:Setup(Range,DefaultZero,IgnoreZero)
	self.IgnoreZero = IgnoreZero
	self.DefaultZero = DefaultZero
	if Range then self:SetBeamLength(Range) end
end

function ENT:TriggerInput(iname, value)
	if(iname == "Send")then
		self.Sending = value > 0
	elseif(iname == "Range")then
		self:SetBeamLength(math.Clamp(value,0,32000))
	else
		self.Values[iname] = value
	end
end

function ENT:Think()
	self:NextThink(CurTime()+0.125)
	if(self.Activated == false and self.DefaultZero)then
		WireLib.TriggerOutput(self,"A",0)
		WireLib.TriggerOutput(self,"B",0)
		WireLib.TriggerOutput(self,"C",0)
		WireLib.TriggerOutput(self,"D",0)
		WireLib.TriggerOutput(self,"E",0)
		WireLib.TriggerOutput(self,"F",0)
		WireLib.TriggerOutput(self,"G",0)
		WireLib.TriggerOutput(self,"H",0)
	else
		if(CurTime() > self.ActivateTime + 0.5)then
			self.Activated = false
		end
	end


	local vStart = self:GetPos()
	local vForward = self:GetUp()

	local trace = {}
	   trace.start = vStart
	   trace.endpos = vStart + (vForward * self:GetBeamLength())
	   trace.filter = { self }
	local trace = util.TraceLine( trace )

	local ent = trace.Entity

	if not IsValid(ent) then
		self:SetColor(Color(255, 255, 255, 255))
		return true
	end

	self:SetColor(Color(0, 255, 0, 255))

	if ent:GetClass() == "gmod_wire_data_transferer" then
		ent:ReceiveValue("A",self.Values.A)
		ent:ReceiveValue("B",self.Values.B)
		ent:ReceiveValue("C",self.Values.C)
		ent:ReceiveValue("D",self.Values.D)
		ent:ReceiveValue("E",self.Values.E)
		ent:ReceiveValue("F",self.Values.F)
		ent:ReceiveValue("G",self.Values.G)
		ent:ReceiveValue("H",self.Values.H)
	elseif ent:GetClass() == "gmod_wire_data_satellitedish" then
		if IsValid(ent.Transmitter) then
			ent.Transmitter:ReceiveValue("A",self.Values.A)
			ent.Transmitter:ReceiveValue("B",self.Values.B)
			ent.Transmitter:ReceiveValue("C",self.Values.C)
			ent.Transmitter:ReceiveValue("D",self.Values.D)
			ent.Transmitter:ReceiveValue("E",self.Values.E)
			ent.Transmitter:ReceiveValue("F",self.Values.F)
			ent.Transmitter:ReceiveValue("G",self.Values.G)
			ent.Transmitter:ReceiveValue("H",self.Values.H)
		else
			self:SetColor(Color(255, 0, 0, 255))
		end
	elseif ent:GetClass() == "gmod_wire_data_store" then
		WireLib.TriggerOutput(self,"A",ent.Values.A)
		WireLib.TriggerOutput(self,"B",ent.Values.B)
		WireLib.TriggerOutput(self,"C",ent.Values.C)
		WireLib.TriggerOutput(self,"D",ent.Values.D)
		WireLib.TriggerOutput(self,"E",ent.Values.E)
		WireLib.TriggerOutput(self,"F",ent.Values.F)
		WireLib.TriggerOutput(self,"G",ent.Values.G)
		WireLib.TriggerOutput(self,"H",ent.Values.H)
		if(self.Sending)then
			ent.Values.A = self.Inputs["A"].Value
			ent.Values.B = self.Inputs["B"].Value
			ent.Values.C = self.Inputs["C"].Value
			ent.Values.D = self.Inputs["D"].Value
			ent.Values.E = self.Inputs["E"].Value
			ent.Values.F = self.Inputs["F"].Value
			ent.Values.G = self.Inputs["G"].Value
			ent.Values.H = self.Inputs["H"].Value
		end
	else
		self:SetColor(Color(255, 255, 255, 255))
	end
	return true
end

function ENT:ReceiveValue(output,value)
	self.Activated = true
	self.ActivateTime = CurTime()
	if value ~= 0 or not self.IgnoreZero then
		WireLib.TriggerOutput(self,output,value)
	end
end

duplicator.RegisterEntityClass("gmod_wire_data_transferer", WireLib.MakeWireEnt, "Data", "Range", "DefaultZero", "IgnoreZero")
