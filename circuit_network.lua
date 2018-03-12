require "debug"

local CircuitNetwork = {}

--- Return the specified signal from the wire
--- @param control the control behavior
--- @param wire the red or green wire to get the signals from. @see defines.wire_type
--- @param circuit_connector input or output of the circuit control network @see defines.circuit_connector_id
--- @return all signals from the specified wire and circuit connector
function get_signals(control, wire, circuit_connector)
    if wire ~= defines.wire_type.red and wire ~= defines.wire_type.green then
        logw("Invalid wire type: " .. wire)
        return
    end
    if circuit_connector ~= defines.circuit_connector_id.combinator_input and circuit_connector ~= defines.circuit_connector_id.combinator_output then
        logw("Invalid circuit_connector_id: " .. circuit_connector)
        return
    end

    local circuit_network = control.get_circuit_network(wire, circuit_connector)
    if circuit_network then
        return circuit_network.signals
    end
end

--- Add signal to the specified array. If the signal already exists it will add that result
--- @param from the signal array to add from
--- @param to the array to add to
function add_signals(from, to)
    for k, signal_container in pairs(from) do
        local signal = signal_container.signal
        local id = signal.name
        local count = signal_container.count
        if to[id] ~= nil then
            logd("Updating count to " .. (to[id].count + count))
            to[id].count = to[id].count + count
        else
            local signal_info = {
                signal = signal,
                count = count,
            }
            to[id] = signal_info
        end
    end
end

--- Return the input from a control
--- @param control the control behavior from an arithmetic combinator
--- @return all signal inputs for the combinator
function CircuitNetwork.get_input(control)
    local red_input = get_signals(control, defines.wire_type.red, defines.circuit_connector_id.combinator_input)
    local green_input = get_signals(control, defines.wire_type.green, defines.circuit_connector_id.combinator_input)

    -- Add inputs from both wires
    local input = {}
    if red_input then
        add_signals(red_input, input)
    end
    if green_input then
        add_signals(green_input, input)
    end

    return input
end

--- Set the output signal of the control parameters
--- @param control the combinator control to change the output signal for
--- @param output_signal new output_signal
function CircuitNetwork.set_output_signal(control, output_signal)
    local new_parameters = control.parameters.parameters
    new_parameters.output_signal = output_signal
    control.parameters = {
        parameters = new_parameters
    }
end

--- Set the operation of the combinator
--- @param control the arithmetic combinator control behavior to set the operation for
--- @param operation new operation for the combinator
function CircuitNetwork.set_operation(control, operation)
    local new_parameters = control.parameters.parameters
    new_parameters.operation = operation
    control.parameters = {
        parameters = new_parameters
    }
end

return CircuitNetwork